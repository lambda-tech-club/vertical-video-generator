# 縦型動画生成スクリプト

横動画から縦動画を生成するスクリプト

https://github.com/user-attachments/assets/a45baaea-db6f-495e-b3db-3513930aa03f

## インストール

```bash
brew install ffmpeg
git clone https://github.com/lambda-tech-club/vertical-video-generator
cd vertical-video-generator
chmod +x generator.sh
```

## 使い方

```bash
./generate.sh -b BASE_FILE -i VIDEO_FILE -o OUTPUT_FILE -t TEXT [-a ADDITIONAL_TEXT] [-f FONT_FILE] [-F DEFAULT_FONT_SIZE] [-p PADDING] [-S OUTPUT_SCALE] [-V VIDEO_SCALE] [-y VIDEO_OFFSET] [-T TEXT_OFFSET]
```

| オプション | 変数名 | 説明 |
| :--------- | :----- | :--- |
| -b | BASE_FILE | テンプレート画像のファイル名（必須） |
| -i | VIDEO_FILE | 入力する横動画のファイル名（必須） |
| -o | OUTPUT_FILE | 出力ファイル名（必須） |
| -t | TEXT | タイトルテキスト（必須） |
| -a | ADDITIONAL_TEXT | 2行目のテキスト |
| -f | FONT_FILE | タイトルテキストのフォント |
| -F | DEFAULT_FONT_SIZE | タイトルテキストのフォントサイズ |
| -p | PADDING | タイトルテキスト左右の余白 |
| -S | OUTPUT_SCALE | 出力動画のサイズ |
| -V | VIDEO_SCALE | 埋め込む横動画のサイズ |
| -y | VIDEO_OFFSET | 埋め込む横動画の縦方向オフセット |
| -T | TEXT_OFFSET | タイトルテキストの縦方向オフセット |

### 1行タイトルテキストを追加

```bash
./generate.sh -b sample/template.png -i sample/video.mp4 \
-o output.mp4 -t "あいうえお"
```

### 2行タイトルテキストを追加

```bash
./generate.sh -b sample/template.png -i sample/video.mp4 \
-o output.mp4 -t "あいうえお" -a "かきくけこ"
```

### フォントファイルとフォントサイズを指定

```bash
./generate.sh -b sample/template.png -i sample/video.mp4 \
-o output.mp4 -t "あいうえお" \
-f "/System/Library/Fonts/ヒラギノ角ゴシック W8.ttc" -F 120
```

### 埋め込む横動画が左右をはみ出さないようにする

```bash
./generate.sh -b sample/template.png -i sample/video.mp4 \
-o output.mp4 -t "あいうえお" -V 1072:603
```

### 埋め込む横動画を上下中央に配置する

```bash
./generate.sh -b sample/template.png -i sample/video.mp4 \
-o output.mp4 -t "あいうえお" -y 0
```

### タイトルテキストを真上に配置する

```bash
./generate.sh -b sample/template.png -i sample/video.mp4 \
-o output.mp4 -t "あいうえお" -T 0
```

### 文字サイズを120にする

```bash
./generate.sh -b sample/template.png -i sample/video.mp4 \
-o output.mp4 -t "あいうえお" -F 120
```

### 720pで生成する

```bash
./generate.sh -b sample/template.png -i sample/video.mp4 \
-o output.mp4 -t "あいうえお" \
-S 720:1280 -V 720:406 -y -98 -T 262
```

## 推奨仕様

| 項目 | テンプレート画像 | 入力動画 |
| :--- | :--------------- | :------- |
| アスペクト比 | 9:16 | 16:9 |
| 解像度 | 1080x1920 | 1920x1080 |
| フォーマット | PNG | MP4 |
