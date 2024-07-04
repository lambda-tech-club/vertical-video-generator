# 縦型動画生成スクリプト

横動画から縦動画を生成するスクリプト

## インストール

```bash
brew install ffmpeg
git clone https://github.com/lambda-tech-club/vertical-video-generator
cd vertical-video-generator
chmod +x generator.sh
```

## 使い方

```bash
./generate.sh -b BASE_FILE -i VIDEO_FILE -t TEXT [-a ADDITIONAL_TEXT] [-f FONT_FILE] -o OUTPUT_FILE
```

| オプション | 変数名 | 説明 |
| :--------- | :----- | :--- |
| -b | BASE_FILE | テンプレート画像のファイル名 |
| -i | VIDEO_FILE | 入力する横動画のファイル名 |
| -t | TEXT | タイトルテキスト |
| -a | ADDITIONAL_TEXT | 2行目のテキスト（任意） |
| -f | FONT_FILE | タイトルテキストのフォント |
| -o | OUTPUT_FILE | 出力ファイル名 |

### 1行タイトルテキストを追加

```bash
./generate.sh -b sample/template.png -i sample/video.mp4 \
-t "あいうえお" \
-o output.mp4
```

### 2行タイトルテキストを追加

```bash
./generate.sh -b sample/template.png -i sample/video.mp4 \
-t "あいうえお" \
-a "かきくけこ" \
-o output.mp4
```

### フォントファイルを指定

```bash
./generate.sh -b sample/template.png -i sample/video.mp4 \
-t "あいうえお" \
-f "/System/Library/Fonts/ヒラギノ角ゴシック W8.ttc" \
-o output.mp4
```

## 調整

`generate.sh`の変数を編集する

### 生成する動画ファイルのサイズを変更

```bash
OUTPUT_SCALE="1080:1920" # 出力ファイルのサイズ
```

#### 例：720pにする場合

```bash
OUTPUT_SCALE="720:1280" # 出力ファイルのサイズ
```

### 配置する横動画のサイズと配置位置を変更

```bash
VIDEO_SCALE="1088:612" # 配置するビデオの変換後サイズ
VIDEO_OFFSET=-147 # ビデオの配置場所（中央基準）
```

#### 例：左右をはみ出さないようにする場合

```bash
VIDEO_SCALE="1072:603" # 配置するビデオの変換後サイズ
VIDEO_OFFSET=-147 # ビデオの配置場所（中央基準）
```

#### 例：中央に配置する場合

```bash
VIDEO_SCALE="1088:612" # 配置するビデオの変換後サイズ
VIDEO_OFFSET=0 # ビデオの配置場所（中央基準）
```

### タイトルテキストの位置とフォントを変更

```bash
TEXT_OFFSET=400 # タイトルテキストの配置場所（上基準）
FONT_FILE="/System/Library/Fonts/ヒラギノ角ゴシック W8.ttc" # タイトルフォント
```

#### 例：真上に配置する場合

```bash
TEXT_OFFSET=0 # タイトルテキストの配置場所（上基準）
FONT_FILE="/System/Library/Fonts/ヒラギノ角ゴシック W8.ttc" # タイトルフォント
```

#### 例：フォントウエイトをW6にする場合

```bash
TEXT_OFFSET=0 # タイトルテキストの配置場所（上基準）
FONT_FILE="/System/Library/Fonts/ヒラギノ角ゴシック W6.ttc" # タイトルフォント
```

### タイトルテキストの位置とフォントを変更

```bash
DEFAULT_FONT_SIZE=184 # 標準文字サイズ
DEFAULT_TEXT_LENGTH=5 # 標準文字数
```

#### 例：文字サイズを120にする場合

```bash
DEFAULT_FONT_SIZE=120 # 標準文字サイズ
DEFAULT_TEXT_LENGTH=5 # 標準文字数
```
