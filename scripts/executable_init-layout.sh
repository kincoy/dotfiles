#!/usr/bin/env bash

YABAI="/opt/homebrew/bin/yabai"

# ------------------------------
# 获取主显示器（index 最小）
# ------------------------------
get_primary_display() {
	$YABAI -m query --displays |
		jq -r 'sort_by(.index) | .[0].index'
}

# 获取副显示器
get_secondary_display() {
	$YABAI -m query --displays |
		jq -r 'sort_by(.index) | .[1].index'
}

# ------------------------------
# 重置 display 的 space 数量
# ------------------------------
reset_spaces() {
	DISPLAY="$1"
	TARGET="$2"

	# 获取当前所有 space id
	CURRENT_SPACES=$(
		$YABAI -m query --displays |
			jq -r --argjson d "$DISPLAY" '.[] | select(.index==$d) | .spaces | .[]'
	)

	CURRENT_COUNT=$(echo "$CURRENT_SPACES" | wc -l | tr -d ' ')

	# 如果空间太多，删除多余的
	while [ "$CURRENT_COUNT" -gt "$TARGET" ]; do
		LAST_ID=$(echo "$CURRENT_SPACES" | tail -1)
		echo "🗑️  Removing space $LAST_ID from display $DISPLAY"
		$YABAI -m space "$LAST_ID" --destroy
		CURRENT_SPACES=$(
			$YABAI -m query --displays |
				jq -r --argjson d "$DISPLAY" '.[] | select(.index==$d) | .spaces | .[]'
		)
		CURRENT_COUNT=$(echo "$CURRENT_SPACES" | wc -l | tr -d ' ')
	done

	# 如果空间不够，创建新的
	while [ "$CURRENT_COUNT" -lt "$TARGET" ]; do
		echo "➕ Adding space to display $DISPLAY (current: $CURRENT_COUNT, target: $TARGET)"
		$YABAI -m display --focus "$DISPLAY"
		$YABAI -m space --create
		sleep 0.3
		CURRENT_COUNT=$((CURRENT_COUNT + 1))
	done
}

# ------------------------------
# 获取 display 内第 N 个 space id
# ------------------------------
get_space_id() {
	DISPLAY="$1"
	POSITION="$2"

	$YABAI -m query --displays |
		jq -r --argjson d "$DISPLAY" --argjson p "$POSITION" '
        .[] | select(.index==$d) | .spaces[$p - 1]
      '
}

# ------------------------------
# 移动 app
# ------------------------------
move_app() {
	APP="$1"
	DISPLAY="$2"
	POS="$3"

	SPACE_ID=$(get_space_id "$DISPLAY" "$POS")

	if [ -z "$SPACE_ID" ] || [ "$SPACE_ID" = "null" ]; then
		echo "⚠️  space $POS not found on display $DISPLAY"
		return
	fi

	$YABAI -m query --windows |
		jq -r --arg app "$APP" '.[] | select(.app==$app) | .id' |
		while read -r wid; do
			if [ -n "$wid" ]; then
				echo "→ $APP → display $DISPLAY space $POS (window: $wid)"
				$YABAI -m window "$wid" --display "$DISPLAY" 2>/dev/null
				$YABAI -m window "$wid" --space "$SPACE_ID" 2>/dev/null
			fi
		done
}

# ------------------------------
# 主逻辑
# ------------------------------

PRIMARY=$(get_primary_display)
SECONDARY=$(get_secondary_display)

echo "Primary display: $PRIMARY"
echo "Secondary display: $SECONDARY"

# 主屏需要 7 个 space
reset_spaces "$PRIMARY" 7

# 副屏需要 3 个 space
reset_spaces "$SECONDARY" 3

# ------------------------------
# 显示器 1（主工作环境）
# ------------------------------

# 2 聊天
move_app "QQ" "$PRIMARY" 2
move_app "WeChat" "$PRIMARY" 2
move_app "微信" "$PRIMARY" 2
move_app "Slack" "$PRIMARY" 2
move_app "Discord" "$PRIMARY" 2
move_app "Telegram" "$PRIMARY" 2

# 3 终端
move_app "Alacritty" "$PRIMARY" 3

# 4 浏览器
move_app "Arc" "$PRIMARY" 4

# 5-7 IDE
move_app "GoLand" "$PRIMARY" 5
move_app "IntelliJ IDEA" "$PRIMARY" 6
move_app "PyCharm" "$PRIMARY" 7
move_app "WebStorm" "$PRIMARY" 7
move_app "CLion" "$PRIMARY" 7
move_app "Rider" "$PRIMARY" 7

# ------------------------------
# 显示器 2（消息查看）
# ------------------------------

# 1 飞书 + 音乐
move_app "Feishu" "$SECONDARY" 1
move_app "QQ音乐" "$SECONDARY" 1
move_app "网易云音乐" "$SECONDARY" 1

# 2 工具
move_app "ChatGPT" "$SECONDARY" 2
move_app "Postman" "$SECONDARY" 2
move_app "Sublime Text" "$SECONDARY" 2
move_app "CorpLink" "$SECONDARY" 2

# 3 Notion
move_app "Notion" "$SECONDARY" 3

# 重平衡（重新获取最新的 space id）
CURRENT_SPACES=$($YABAI -m query --spaces | jq -r '.[].id')
for sid in $CURRENT_SPACES; do
	$YABAI -m space "$sid" --balance 2>/dev/null
done

echo "✅ deterministic layout applied"
