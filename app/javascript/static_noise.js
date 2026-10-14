// Static noise behind the whole site: a 1024px tile of 1px grain, tiled on an
// oversized fixed layer that jumps around in steps (see #static-noise in mono.css).
// Attached to <html> so Turbo body swaps do not remove it.
const TILE = 1024;

const tile = document.createElement("canvas");
tile.width = tile.height = TILE;
const ctx = tile.getContext("2d");
const img = ctx.createImageData(TILE, TILE);
const d = img.data;
for (let i = 0; i < d.length; i += 4) {
  d[i] = d[i + 1] = d[i + 2] = 255;
  d[i + 3] = Math.random() ** 3 * 255; // skewed low: sparse bright specks, small mean lift
}
ctx.putImageData(img, 0, 0);

const layer = document.createElement("div");
layer.id = "static-noise";
layer.setAttribute("aria-hidden", "true");
tile.toBlob((blob) => {
  layer.style.backgroundImage = `url(${URL.createObjectURL(blob)})`;
  document.documentElement.prepend(layer);
});
