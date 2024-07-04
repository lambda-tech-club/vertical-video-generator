#!/bin/bash

set -e

# 初期値の設定
OUTPUT_SCALE="1080:1920" # 出力ファイルのサイズ
VIDEO_SCALE="1088:612" # 配置するビデオの変換後サイズ
VIDEO_OFFSET=-147 # ビデオの配置場所（中央基準）
TEXT_OFFSET=400 # タイトルテキストの配置場所（上基準）
FONT_FILE="/System/Library/Fonts/ヒラギノ角ゴシック W8.ttc" # タイトルフォント
DEFAULT_FONT_SIZE=184 # 標準文字サイズ
DEFAULT_TEXT_LENGTH=5 # 標準文字数

# 引数のパース
while getopts ":b:v:i:t:a:o:" opt; do
    case $opt in
        b) BASE_FILE="$OPTARG"
        ;;
        i) VIDEO_FILE="$OPTARG"
        ;;
        f) FONT_FILE="$OPTARG"
        ;;
        t) TEXT="$OPTARG"
        ;;
        a) ADDITIONAL_TEXT="$OPTARG"
        ;;
        o) OUTPUT_FILE="$OPTARG"
        ;;
        \?) echo "Invalid option -$OPTARG" >&2
            echo "Usage: $0 -b BASE_FILE -i VIDEO_FILE -t TEXT [-a ADDITIONAL_TEXT] [-f FONT_FILE] -o OUTPUT_FILE"
            exit 1
        ;;
        :) echo "Option -$OPTARG requires an argument." >&2
           echo "Usage: $0 -b BASE_FILE -i VIDEO_FILE -t TEXT [-a ADDITIONAL_TEXT] [-f FONT_FILE] -o OUTPUT_FILE"
           exit 1
        ;;
    esac
done

# 引数のチェック
if [ -z "$BASE_FILE" ] || [ -z "$VIDEO_FILE" ] || [ -z "$TEXT" ] || [ -z "$OUTPUT_FILE" ]; then
    echo "Usage: $0 -b BASE_FILE -i VIDEO_FILE -t TEXT [-a ADDITIONAL_TEXT] [-f FONT_FILE] -o OUTPUT_FILE"
    exit 1
fi

# 文字数に基づいてフォントサイズを計算
MAX_LENGTH=${#TEXT}
if [ -n "$ADDITIONAL_TEXT" ]; then
    # 2行の場合は文字数が多い方に合わせる
    MAX_LENGTH=$((${#TEXT} > ${#ADDITIONAL_TEXT} ? ${#TEXT} : ${#ADDITIONAL_TEXT}))
fi

if [ $MAX_LENGTH -gt $DEFAULT_TEXT_LENGTH ]; then
    # 規定文字数以上の場合は文字数に合わせてサイズを調整
    FONT_SIZE=$(echo "$DEFAULT_FONT_SIZE * ($DEFAULT_TEXT_LENGTH / $MAX_LENGTH)" | bc -l | awk '{printf "%d", $1}')
else
    FONT_SIZE=$DEFAULT_FONT_SIZE
fi

# ffmpegコマンドを生成して実行
if [ -n "$ADDITIONAL_TEXT" ]; then
    # タイトルテキストが2行の場合
    ffmpeg -i "$BASE_FILE" -i "$VIDEO_FILE" -filter_complex "\
    [0:v]scale=$OUTPUT_SCALE[template];\
    [1:v]scale=$VIDEO_SCALE[video];\
    [template][video]overlay=x=(W-w)/2:y=(H-h)/2$VIDEO_OFFSET[overlay];\
    [overlay]drawtext=fontfile=$FONT_FILE:text='$TEXT':x=(w-text_w)/2:y=$TEXT_OFFSET-$FONT_SIZE:fontcolor=white:fontsize=$FONT_SIZE[text1];\
    [text1]drawtext=fontfile=$FONT_FILE:text='$ADDITIONAL_TEXT':x=(w-text_w)/2:y=$TEXT_OFFSET:fontcolor=white:fontsize=$FONT_SIZE\
    " "$OUTPUT_FILE"
else
    # タイトルテキストが1行の場合
    ffmpeg -i "$BASE_FILE" -i "$VIDEO_FILE" -filter_complex "\
    [0:v]scale=$OUTPUT_SCALE[template];\
    [1:v]scale=$VIDEO_SCALE[video];\
    [template][video]overlay=x=(W-w)/2:y=(H-h)/2$VIDEO_OFFSET[overlay];\
    [overlay]drawtext=fontfile=$FONT_FILE:text='$TEXT':x=(w-text_w)/2:y=$TEXT_OFFSET-$FONT_SIZE/2:fontcolor=white:fontsize=$FONT_SIZE\
    " "$OUTPUT_FILE"
fi
