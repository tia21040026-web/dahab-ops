"""Screenshot analyzer — the agent's 'eyes' on the device.

Reports:
- keyboard: is a (light) soft keyboard covering the bottom of the screen?
- teal_rows: y-ranges of teal (action/focus) pixels -> focused field / buttons
- bright_rows: y-ranges of large light regions (panels/dialogs on dark theme)
- dark: overall theme darkness
"""
import sys
from PIL import Image

def rows_with(im, test, min_count=6):
    w, h = im.size
    px = im.load()
    rows = []
    cur = None
    for y in range(0, h, 4):
        cnt = 0
        for x in range(0, w, 3):
            if test(px[x, y]):
                cnt += 1
        if cnt >= min_count:
            if cur and y - cur[1] <= 8:
                cur = (cur[0], y, max(cur[2], cnt))
            else:
                if cur:
                    rows.append(cur)
                cur = (y, y, cnt)
    if cur:
        rows.append(cur)
    return rows

def main(path):
    im = Image.open(path).convert("RGB")
    w, h = im.size
    scale = 2340 / h  # actual height / thumb height

    # Teal (action color ~#3CC2BC dark / ~#0E7C7A light)
    def teal(c):
        r, g, b = c
        return g > 100 and b > 90 and g > r + 30 and b > r + 10 and abs(int(g) - int(b)) < 70 and g - b < 60

    # Light pixels (keyboard, light surfaces)
    def light(c):
        r, g, b = c
        return r > 170 and g > 170 and b > 170

    tot = 0
    n = 0
    px = im.load()
    for y in range(0, h, 8):
        for x in range(0, w, 8):
            r, g, b = px[x, y]
            tot += (r + g + b) / 3
            n += 1
    brightness = tot / max(n, 1)

    bottom = im.crop((0, int(h * 0.62), w, h))
    bpx = bottom.load()
    bw, bh = bottom.size
    light_bottom = sum(1 for y in range(0, bh, 4) for x in range(0, bw, 4)
                       if bpx[x, y][0] > 170 and bpx[x, y][1] > 170 and bpx[x, y][2] > 170)
    bottom_samples = (bh // 4 + 1) * (bw // 4 + 1)
    kb = light_bottom / max(bottom_samples, 1) > 0.28

    teals = rows_with(im, teal, min_count=8)
    print(f"size={w}x{h} scale_to_2340={scale:.2f} brightness={brightness:.0f} keyboard={'YES' if kb else 'no'}")
    if teals:
        parts = []
        for (y0, y1, cnt) in teals[:12]:
            parts.append(f"y{int(y0*scale)}-{int(y1*scale)}(n{cnt})")
        print("teal:", " ".join(parts))
    else:
        print("teal: none")

if __name__ == "__main__":
    main(sys.argv[1])
