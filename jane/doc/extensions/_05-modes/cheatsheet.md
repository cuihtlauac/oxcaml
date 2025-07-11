---
layout: documentation-page
collectionName: Modes
title: Cheat Sheet
---

<style>
.table {
    width: fit-content;
    margin-left: auto;
    margin-right: auto;
    margin-bottom: 20px;
    border-style: solid;
    border-color: blue;
    border-radius: 25px;
    padding: 15px;
    text-align: center;
}
</style>

This table explains how compile-time locality requirements are turned into runtime allocation requirements.


| Mode   | Lifetime                    | Allocation            |
| ------ | --------------------------- | --------------------- |
| **`global`** | MAY outlive its region      | MUST be on the heap   |
| `local`  | MUST NOT outlive its region | MAY be on the stack   |

This table list all the modal axes, modes, mode orders, and mode crossings. Mode crossing is represented using a color code. Blues applies to functions related values, red applies to “deeply immutable” values, black is others.

<div style="display: flex">
<table style="border-collapse: collapse; width: 100%;">
<thead>
<tr>
<th style="width: 50px;"></th>
<th style="text-align: left; ">Past</th>
<th style="text-align: right;">Future</th>
</tr>
</thead>
<tbody>
<tr>
<td style="font-weight: bold; writing-mode: sideways-lr; text-align: center;">Region</td>
<td style="text-align: left;"> </td>
<td style="text-align: right;">Locality<br><code><strong>global</strong> < local</code></td>
</tr>
<tr>
<td style="font-weight: bold; writing-mode: sideways-lr; text-align: center;">Aliasing</td>
<td style="text-align: left;">Uniqueness<br><code>unique < <strong>aliased</strong></code></td>
<td style="text-align: right;"><span style="color: blue;">Affinity</span><br><code><strong>many</strong> < once</code></td>
</tr>
<tr>
<td style="font-weight: bold; writing-mode: sideways-lr; text-align: center;">Threads<br></td>
<td style="text-align: left;"><span style="color: red;">Contention</span> <br><code><strong>uncontended</strong> < shared < contended</code></td>
<td style="text-align: right;"><span style="color: blue;">Portability</span><br><code>portable < <strong>nonportable</strong></code></td>
</tr>
<tr>
<td style="font-weight: bold; writing-mode: sideways-lr; text-align: center;">Purity</td>
<td style="text-align: left;"><span style="color: red;">Visibility</span><br><code><strong>read_write</strong> < read < immutable</code></td>
<td style="text-align: right;"><span style="color: blue;">Statefulness</span><br><code>stateless < observing < <strong>stateful</strong></code></td>
</tr>
<tr>
<td style="font-weight: bold; writing-mode: sideways-lr; text-align: center;">Effects</td>
<td style="text-align: left;"></td>
<td style="text-align: right;"><span style="color: blue;">Yielding</span><br><code><strong>unyielding</strong> < yielding</code></td>
</tr>
</tbody>
</table>
</div>

This table summarizes the inter-axes allowed capture rules. Colors are for modal axes, grouped by duality. A check mark means a closure at the above mode, can capture a value at left mode, color-wise.

<div style="display: flex; justify-content: center;">
<table style="border-collapse: collapse; vertical-align: middle; text-align: center;">
<tr>
<td></td>
<td></td>
<td colspan="4" style="font-weight:bold;">Future Closure</td>
</tr>
<tr>
<td style=" "></td>
<td style="font-weight: bold;"><span style="color: DarkRed">Aliasing</span><br><span style="color: DarkGreen">Threads</span><br><span style="color: DarkBlue">Purity</span></td>
<td>
  <code><strong><span style="color: DarkRed">many</span></strong></code><br>
  <code><span style="color: DarkGreen">portable</span></code><br>
  <code><span style="color: DarkBlue">stateless</span></code></td>
<td>
  <br>
  <br>
  <code><span style="color: DarkBlue">observing</span></code></td>
<td>
  <code><span style="color: DarkRed">once</span></code><br>
  <code><strong><span style="color: DarkGreen">nonportable</span></strong></code><br>
  <code><strong><span style="color: DarkBlue">stateful</span></strong></code></td>
</tr>
<tr>
<td rowspan="3" style="writing-mode: sideways-lr; font-weight: bold;">Captured Past</td>
<td>
  <code><strong><span style="color: DarkRed">aliased</span></strong></code><br>
  <code><span style="color: DarkGreen">contended</span></code><br>
  <code><span style="color: DarkBlue">immutable</span></code></td>
<td>&check;</td>
<td>&check;</td>
<td>&check;</td>
</tr>
<tr>
<td>
  <br>
  <code><span style="color: DarkGreen">shared</span></code><br>
  <code><span style="color: DarkBlue">read</span></code></td>
<td></td>
<td>&check;</td>
<td>&check;</td>
</tr>
<tr>
<td>
  <code><span style="color: DarkRed">unique</spa></code><br>
  <code><strong><span style="color: DarkGreen">uncontended</span></strong></code><br>
  <code><strong><span style="color: DarkBlue">read_write</span></strong></code></td>
<td></td>
<td></td>
<td>&check;</td>
</tr>
</table>
</div>
