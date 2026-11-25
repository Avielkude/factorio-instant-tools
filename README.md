# Instant Tools

**Author:** Avielkude

**Instant Tools** adds batch destroy / copy / move tools to Factorio 2.1, based on a simple area selection with the deconstruction planner.
It also provides a ghost preview, rotation, undo, and colored map planning zones.

> 涓枃璇存槑瑙佷笅鏂广€? Chinese documentation is below.

---

## English

### Features

| Feature | Description |
|---|---|
| Batch destroy | Select an area with the deconstruction planner and everything inside is removed instantly. Buildings and their contents are refunded to your inventory. |
| Batch copy | Copies the selected area (optionally with container/inventory contents) into a clipboard. |
| Batch move | Removes the selected area and lets you place it somewhere else, keeping contents. |
| Ghost preview | After copy/move, blue ghost outlines show where the build will land. The preview follows you. |
| Smart anchor | The build is horizontally centered on you and placed 3 tiles above your position, so it never overlaps the character. |
| Rotation | Rotate the whole build (positions + directions) by 90 degrees. |
| Undo | Restore the last move to its original location. |
| Planning zones | Draw semi-transparent colored zones with labels on the map to plan production areas. Overlay can be toggled on/off. |

### Hotkeys

| Key | Action |
|---|---|
| `Alt + M` | Cycle mode: destroy -> copy -> move |
| `Alt + C` | Paste the clipboard at the anchor position |
| `Alt + R` | Rotate the clipboard 90 degrees clockwise |
| `Alt + X` | Cancel clipboard / preview |
| `Alt + U` | Undo the last move |
| `Alt + P` | Toggle planning mode (next area selection creates a planning zone) |
| `Alt + O` | Show / hide all planning zones |

All keys can be rebound in **Settings -> Controls -> Mods -> Instant Tools**.

### Settings

| Setting | Default | Description |
|---|---|---|
| Copy contents | on | When copying, also copy the contents of containers / machine inventories. |

### Installation

1. Download the latest release (`instant-tools_x.y.z.zip`).
2. Put the zip into your Factorio mods folder:
   - Windows: `%APPDATA%\Factorio\mods`
   - Linux: `~/.factorio/mods`
   - macOS: `~/Library/Application Support/factorio/mods`
3. Start Factorio and enable **Instant Tools** in the mod manager.

### Notes

- This mod is designed for single player and QoL/creative use. Copying and moving is free and does not require construction robots.
- Undo only keeps the most recent move.
- Planning zones are rendering-only and do not affect buildings or collisions.
- Compatible with Factorio 2.1.

### License

MIT

---

## 涓枃

### 鍔熻兘

| 鍔熻兘 | 璇存槑 |
|---|---|
| 鎵归噺鎷嗛櫎 | 鐢ㄦ媶闄よ鍒掑櫒妗嗛€変竴鐗囧尯鍩燂紝鍖哄煙鍐呭缓绛戠珛鍗虫竻闄わ紝寤虹瓚鏈綋鍜屽唴閮ㄧ墿鍝佽繑杩樺埌鑳屽寘銆?|
| 鎵归噺澶嶅埗 | 鎶婃閫夊尯鍩燂紙鍙€夋嫨鏄惁鍖呭惈绠卞瓙/鏈哄櫒鍐呯殑鐗╁搧锛夊鍒跺埌鍓创鏉裤€?|
| 鎵归噺绉诲姩 | 绉婚櫎妗嗛€夊尯鍩燂紝骞跺湪鐩爣浣嶇疆閲嶅缓锛岀墿鍝佸唴瀹逛竴璧风Щ鍔ㄣ€?|
| 钃濊壊骞界伒棰勮 | 澶嶅埗/绉诲姩鍚庢樉绀鸿摑鑹茶櫄绾胯疆寤擄紝棰勮浼氳窡闅忎汉鐗╃Щ鍔紝鏂逛究纭钀界偣銆?|
| 鏅鸿兘瀹氫綅 | 鏁翠綋姘村钩灞呬腑瀵归綈浜虹墿锛屽苟鏀惧湪浜虹墿涓婃柟 3 鏍间箣澶栵紝涓嶄細鍘嬩綇瑙掕壊銆?|
| 鏃嬭浆 | 鏁翠綋锛堜綅缃?+ 鏈濆悜锛夐『鏃堕拡鏃嬭浆 90 搴︺€?|
| 鎾ら攢 | 鎶婃渶杩戜竴娆＄Щ鍔ㄦ仮澶嶅埌鍘熶綅缃€?|
| 瑙勫垝鍖?| 鍦ㄥ湴鍥句笂鐢诲嚭鍗婇€忔槑褰╄壊鍖哄潡鍜岀紪鍙锋爣绛撅紝鐢ㄤ簬瑙勫垝宸ヤ笟鍖?鍖栧伐鍖虹瓑锛涘彲涓€閿樉绀烘垨闅愯棌銆?|

### 蹇嵎閿?
| 鎸夐敭 | 鍔熻兘 |
|---|---|
| `Alt + M` | 鍒囨崲妯″紡锛氭媶闄?鈫?澶嶅埗 鈫?绉诲姩 |
| `Alt + C` | 鍦ㄩ敋鐐逛綅缃矘璐?|
| `Alt + R` | 椤烘椂閽堟棆杞?90掳 |
| `Alt + X` | 鍙栨秷澶嶅埗/棰勮 |
| `Alt + U` | 鎾ら攢鏈€杩戜竴娆＄Щ鍔?|
| `Alt + P` | 杩涘叆/閫€鍑鸿鍒掓ā寮忥紙涓嬩竴娆℃閫夊皢鍒涘缓瑙勫垝鍖猴級 |
| `Alt + O` | 鏄剧ず/闅愯棌鎵€鏈夎鍒掑尯 |

鎵€鏈夋寜閿兘鍙互鍦?**璁剧疆 鈫?鎺у埗 鈫?Mod 鈫?Instant Tools** 涓噸鏂扮粦瀹氥€?
### 璁剧疆椤?
| 璁剧疆 | 榛樿 | 璇存槑 |
|---|---|---|
| 澶嶅埗鏃跺寘鍚墿鍝佸唴瀹?| 寮€ | 澶嶅埗绠卞瓙/鏈哄櫒鏃舵槸鍚︿竴璧峰鍒跺唴閮ㄧ墿鍝併€?|

### 瀹夎鏂规硶

1. 涓嬭浇鏈€鏂板彂甯冨寘锛坄instant-tools_x.y.z.zip`锛夈€?2. 鏀捐繘 mods 鏂囦欢澶癸細
   - Windows锛歚%APPDATA%\Factorio\mods`
   - Linux锛歚~/.factorio/mods`
   - macOS锛歚~/Library/Application Support/factorio/mods`
3. 鍚姩娓告垙锛屽湪妯＄粍绠＄悊閲屽惎鐢?**Instant Tools**銆?
### 娉ㄦ剰浜嬮」

- 鏈?mod 闈㈠悜鍗曚汉娓告垙鍜?QoL / 寤洪€犱究鍒╋紝澶嶅埗鍜岀Щ鍔ㄤ笉娑堣€楃墿鍝侊紝涔熶笉闇€瑕佹満鍣ㄤ汉銆?- 鎾ら攢鍙褰曟渶杩戜竴娆＄Щ鍔ㄣ€?- 瑙勫垝鍖哄彧鏄覆鏌撳眰锛屼笉褰卞搷寤虹瓚鍜岀鎾炪€?- 閫傜敤浜庡紓鏄熷伐鍘?2.1銆?
### 璁稿彲璇?
MIT
