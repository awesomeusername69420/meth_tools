# Meth Tools

Probably has typos, expect jank.

Designed to work with https://methamphetamine.solutions/ but some/most things will work without it.\
*If you are using meth and something breaks, try it without safe mode.*\
⚠ Due to how meth's safe mode works the detours most likely won't work if you run the script in safe mode. ⚠

---

<h3>Swag Tools Commands</h3>

---

<details>
 <summary>Render Commands</summary>
 
 | Command | Description | Argument(s) | Default |
 | --- | --- | --- | --- |
 | st_render_catpng_alpha | Sets alpha value for catpng fov | `integer` | `100` |
 | st_render_catpng_blue | Sets green rgb value for catpng fov | `integer` | `255` |
 | st_render_catpng_green | Sets blue rgb value for catpng fov | `integer` | `255` |
 | st_render_catpng_red | Sets red rgb value for catpng fov | `integer` | `255` |
 | st_render_fov_set | Sets FOV | `integer` | FOV at load time |
 | st_render_tracers_life_set | Sets bullet tracer lifespan (in seconds) | `integer` | `3` |
 | st_render_tracers_max_set | Sets maximum amount of bullet tracers allowed | `integer` | `1000` |
 | st_render_antiblind | Toggles anti ULX blind | `boolean` | `false` |
 | st_render_catpng | Toggles catpng fov rendering | `boolean` | `false` |
 | st_render_fixthirdperson | Toggles thirdperson fix | `boolean` | `false` |
 | st_render_fog | Toggles fog rendering | `boolean` | `true` |
 | st_render_fullbright | Toggles fullbright | `boolean` | `false` |
 | st_render_rgb | Toggles rgb for the LocalPlayer | `boolean` | `false` |
 | st_render_tracers_beam | Toggles bullet tracers being a beam instead of a line | `boolean` | `false` |
 | st_render_tracers_local | Toggles bullet tracers for LocalPlayer | `boolean` | `false` |
 | st_render_tracers_other | Toggles bullet tracers for other players | `boolean` | `false` |
</details>
<details>
 <summary>Tool Commands</summary>
 
 Command | Description | Argument(s) | Default |
 | --- | --- | --- | --- |
 | st_tools_spectatorlist_x | Sets X position for the Spectator list | `integer` | Offset 10 from TDetector list |
 | st_tools_spectatorlist_y | Sets Y position for the Spectator list | `integer` | `10` |
 | st_tools_tdetector_list_x | Sets X position for the TDetector list | `integer` | `10` |
 | st_tools_tdetector_list_y | Sets Y position for the TDetector list | `integer` | `10` |
 | st_tools_gesture_set | Sets gesture for the gestureloop | `string` | `dance` |
 | st_tools_psay_spam_set | Sets message for ULX psay spammer | `string` | `message` |
 | st_tools_allow_guiopenurl | Toggles gui.OpenURL capabilities | `boolean` | `true` |
 | st_tools_antigag | Toggles anti ULX gag | `boolean` | `false` |
 | st_tools_followbot | Toggles block bot/follow bot | `boolean` | `false` |
 | st_tools_gesture_loop | Toggles gestureloop | `boolean` | `false` |
 | st_tools_psay_spam | Toggles ULX psay spammer | `boolean` | `false` |
 | st_tools_spectatorlist | Toggles spectator list | `boolean` | `false` |
 | st_tools_spectatorlist_showall | Toggles spectator list displaying all spectators (Red = on you) | `boolean` | `false` |
 | st_tools_tdetector | Toggles TTT traitor detector | `boolean` | `false` |
 | st_tools_tdetector_drawicons | Toggles rendering of the TDetector's icons above heads | `boolean` | `true` |
 | st_tools_tdetector_drawlist | Toggles rendering of the TDetector's list | `boolean` | `true` |
</details>
<details>
 <summary>Miscellaneous Commands</summary>
 
 Command | Description | Argument(s) | Default |
 | --- | --- | --- | --- |
 | st_alerts | Toggles detour alerts | `boolean` | `true` |
 | st_alerts_sound | Toggles detour alert sound | `boolean` | `true` |
</details>


---

<h3>Test AA Commands</h3>

---

<details>
 <summary>Commands</summary>
 
 Command | Description | Argument(s) | Default |
 | --- | --- | --- | --- |
 | testaa_snapback | Toggles antiaim Snapback | `boolean` | `true` |
 | testaa_lagjitter | Toggles antiaim fakelag jitter | `boolean` | `true` |
 | testaa_jitter | Toggles antiaim jitter | `boolean` | `true` |
 | testaa_autodir | Toggles antiaim auto direction | `boolean` | `false` |
 | testaa_invert | Inverts the antiaim (flips 180 degrees) | | |
</details>

---

<h3>Retarded Circle Strafer Commands</h3>

---

<details>
 <summary>Commands</summary>
 
 Command | Description | Argument(s) | Default |
 | --- | --- | --- | --- |
 | r_cs_size | Changes strafe circle size | `integer` | `5` |
 | r_cs_toggle | Toggles circle strafer | `boolean` | `true` |
 | r_cs_ahop | Toggles auto bhop | `boolean` | `false` |
 | r_cs_astrafe | Toggles auto strafer | `boolean` | `false` |
</details>
