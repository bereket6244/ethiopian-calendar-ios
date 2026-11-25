from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "App" / "Assets.xcassets" / "AppIcon.appiconset" / "AppIcon.png"
SIZE = 1024
image = Image.new("RGB", (SIZE, SIZE))
pixels = image.load()
for y in range(SIZE):
    for x in range(SIZE):
        mix = (x + y) / (2 * SIZE)
        pixels[x, y] = (
            round(8 + 11 * mix),
            round(72 + 54 * mix),
            round(50 + 20 * mix),
        )

draw = ImageDraw.Draw(image)
draw.rounded_rectangle((170, 170, 854, 854), radius=114, fill="#fffaf0")
draw.rounded_rectangle((170, 170, 854, 354), radius=114, fill="#edbe46")
draw.rectangle((170, 280, 854, 354), fill="#edbe46")
draw.rounded_rectangle((304, 112, 372, 238), radius=32, fill="#fffaf0")
draw.rounded_rectangle((652, 112, 720, 238), radius=32, fill="#fffaf0")

font_path = Path("C:/Windows/Fonts/seguibl.ttf")
if not font_path.exists():
    font_path = Path("C:/Windows/Fonts/arialbd.ttf")
font = ImageFont.truetype(str(font_path), 410)
box = draw.textbbox((0, 0), "13", font=font)
text_w, text_h = box[2] - box[0], box[3] - box[1]
draw.text(((SIZE - text_w) / 2 - box[0], 389 - box[1]), "13", font=font, fill="#0c5f3c")

OUT.parent.mkdir(parents=True, exist_ok=True)
image.save(OUT, optimize=True)
image.save(ROOT / "preview" / "icon.png", optimize=True)
print(OUT)
