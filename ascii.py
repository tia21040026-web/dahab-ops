"""Render a screenshot as coarse ASCII so layout structure is readable.

Classes: . dark bg | , dim | # surface/panel | T teal (action) | W warm/coral
         L light/bright (keyboard, salt theme surfaces) | t thin teal (borders)
Grid default 92x34 fits a landscape phone readably.
"""
import sys
from PIL import Image

def classify(c):
    r, g, b = c
    if g > 95 and b > 85 and g > r + 25 and abs(g - b) < 75:
        return "T"
    if r > 200 and g > 200 and b > 200:
        return "L"
    if r > 150 and g > 120 and b < 110:  # warm coral/amber
        return "W"
    if r > 60 and g > 60 and b > 60:
        return "#"
    if r > 25 or g > 25 or b > 25:
        return ","
    return "."

def main(path, cols=92):
    im = Image.open(path).convert("RGB")
    w, h = im.size
    rows = max(1, int(cols * h / w * 0.5))
    cell_w, cell_h = w / cols, h / rows
    out = []
    for gy in range(rows):
        line = []
        for gx in range(cols):
            x0, y0 = int(gx * cell_w), int(gy * cell_h)
            best = [0, 0, 0, 0]  # counts per class index
            order = []
            counts = {}
            for dy in range(0, max(1, int(cell_h)), 2):
                for dx in range(0, max(1, int(cell_w)), 2):
                    c = im.getpixel((min(w - 1, x0 + dx), min(h - 1, y0 + dy)))
                    k = classify(c)
                    counts[k] = counts.get(k, 0) + 1
            # priority: T > L > W > # > , > .
            for k in "TLW#,.":
                if counts.get(k, 0) >= max(2, int(cell_w * cell_h / 40)):
                    line.append(k)
                    break
            else:
                line.append(counts and max(counts, key=counts.get) or ".")
        out.append("".join(line))
    for i, l in enumerate(out):
        y = int(i * cell_h)
        print(f"{y:4d} {l}")

if __name__ == "__main__":
    main(sys.argv[1], int(sys.argv[2]) if len(sys.argv) > 2 else 92)
