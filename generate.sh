#!/bin/bash

set -e

# ffmpegの存在確認
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed. Please install it first." >&2
    echo "Installation instructions: https://ffmpeg.org/download.html" >&2
    exit 1
fi

# 初期値の設定
OUTPUT_SCALE="1080:1920" # 出力ファイルのサイズ
VIDEO_SCALE="1088:612" # 配置するビデオの変換後サイズ
VIDEO_OFFSET=-147 # ビデオの配置場所（中央基準）
TEXT_OFFSET=400 # タイトルテキストの配置場所（上基準）
FONT_FILE="/System/Library/Fonts/ヒラギノ角ゴシック W8.ttc" # タイトルフォント
DEFAULT_FONT_SIZE=184 # 標準文字サイズ
PADDING=160 # タイトルテキストの左右パディング

# 引数のパース
while getopts ":b:i:o:t:a:f:F:p:S:V:y:T:" opt; do
    case $opt in
        b) BASE_FILE="$OPTARG"
        ;;
        i) VIDEO_FILE="$OPTARG"
        ;;
        o) OUTPUT_FILE="$OPTARG"
        ;;
        t) TEXT="$OPTARG"
        ;;
        a) ADDITIONAL_TEXT="$OPTARG"
        ;;
        f) FONT_FILE="$OPTARG"
        ;;
        F) DEFAULT_FONT_SIZE="$OPTARG"
        ;;
        p) PADDING="$OPTARG"
        ;;
        S) OUTPUT_SCALE="$OPTARG"
        ;;
        V) VIDEO_SCALE="$OPTARG"
        ;;
        y) 
            # 正の値なら+を付ける
            if [[ "$OPTARG" -ge 0 ]]; then
                VIDEO_OFFSET="+$OPTARG"
            else
                VIDEO_OFFSET="$OPTARG"
            fi
        ;;
        T) TEXT_OFFSET="$OPTARG"
        ;;
        \?) 
            echo "Invalid option: -$OPTARG" >&2
            echo "Usage: $0 -b BASE_FILE -i VIDEO_FILE -o OUTPUT_FILE -t TEXT [-a ADDITIONAL_TEXT] [-f FONT_FILE] [-F DEFAULT_FONT_SIZE] [-p PADDING] [-S OUTPUT_SCALE] [-V VIDEO_SCALE] [-y VIDEO_OFFSET] [-T TEXT_OFFSET]" >&2
            echo "See the URL for details: https://github.com/lambda-tech-club/vertical-video-generator" >&2
            exit 1
        ;;
        :) 
            echo "Option -$OPTARG requires an argument." >&2
            echo "Usage: $0 -b BASE_FILE -i VIDEO_FILE -o OUTPUT_FILE -t TEXT [-a ADDITIONAL_TEXT] [-f FONT_FILE] [-F DEFAULT_FONT_SIZE] [-p PADDING] [-S OUTPUT_SCALE] [-V VIDEO_SCALE] [-y VIDEO_OFFSET] [-T TEXT_OFFSET]" >&2
            echo "See the URL for details: https://github.com/lambda-tech-club/vertical-video-generator" >&2
            exit 1
        ;;
    esac
done


# 引数のチェック
if [ -z "$BASE_FILE" ] || [ -z "$VIDEO_FILE" ] || [ -z "$TEXT" ] || [ -z "$OUTPUT_FILE" ]; then
    echo "Error: Missing required arguments." >&2
    echo "Usage: $0 -b BASE_FILE -i VIDEO_FILE -o OUTPUT_FILE -t TEXT [-a ADDITIONAL_TEXT] [-f FONT_FILE] [-F DEFAULT_FONT_SIZE] [-p PADDING] [-S OUTPUT_SCALE] [-V VIDEO_SCALE] [-y VIDEO_OFFSET] [-T TEXT_OFFSET]" >&2
    echo "See the following URL for details: https://github.com/lambda-tech-club/vertical-video-generator" >&2
    exit 1
fi

# 文字数に基づいてフォントサイズを計算
TEXT_AREA_WIDTH=$(echo "$(echo "$OUTPUT_SCALE" | cut -d':' -f1) - $PADDING" | bc)

MAX_LENGTH=${#TEXT}
if [ -n "$ADDITIONAL_TEXT" ]; then
    # 2行の場合は文字数が多い方に合わせる
    MAX_LENGTH=$((${#TEXT} > ${#ADDITIONAL_TEXT} ? ${#TEXT} : ${#ADDITIONAL_TEXT}))
fi

FONT_SIZE=$DEFAULT_FONT_SIZE
if [ $((FONT_SIZE * MAX_LENGTH)) -gt $TEXT_AREA_WIDTH ]; then
    FONT_SIZE=$(echo "$TEXT_AREA_WIDTH / $MAX_LENGTH" | bc)
fi

# ffmpegコマンドを生成して実行
if [ -n "$ADDITIONAL_TEXT" ]; then
    # タイトルテキストが2行の場合
    ffmpeg -i "$BASE_FILE" -i "$VIDEO_FILE" -filter_complex "\
    [0:v]scale=$OUTPUT_SCALE[template];\
    [1:v]scale=$VIDEO_SCALE[video];\
    [template][video]overlay=x=(W-w)/2:y=(H-h)/2$VIDEO_OFFSET[overlay];\
    [overlay]drawtext=fontfile=$FONT_FILE:text='$TEXT':x=(w-text_w)/2:y=$TEXT_OFFSET-text_h:fontcolor=white:fontsize=$FONT_SIZE[text1];\
    [text1]drawtext=fontfile=$FONT_FILE:text='$ADDITIONAL_TEXT':x=(w-text_w)/2:y=$TEXT_OFFSET:fontcolor=white:fontsize=$FONT_SIZE\
    " "$OUTPUT_FILE"
else
    # タイトルテキストが1行の場合
    ffmpeg -i "$BASE_FILE" -i "$VIDEO_FILE" -filter_complex "\
    [0:v]scale=$OUTPUT_SCALE[template];\
    [1:v]scale=$VIDEO_SCALE[video];\
    [template][video]overlay=x=(W-w)/2:y=(H-h)/2$VIDEO_OFFSET[overlay];\
    [overlay]drawtext=fontfile=$FONT_FILE:text='$TEXT':x=(w-text_w)/2:y=$TEXT_OFFSET-text_h/2:fontcolor=white:fontsize=$FONT_SIZE\
    " "$OUTPUT_FILE"
fi
