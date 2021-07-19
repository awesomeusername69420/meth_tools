# Meth Tools

Probably has typos, expect jank.

Designed to work with https://methamphetamine.solutions/ but some/most things will work without it.\
*If you are using meth and something breaks, try it without safe mode.*

---

<h3>Swag Tools Commands</h3>

---

<details>
 <summary>Render Commands</summary>
 
 | Command | Description | Argument(s) | Default |
 | --- | --- | --- | --- |
 | m_render_fov_set | Sets FOV | `integer` | FOV at load time |
 | m_render_tracedelay_set | Sets bullet tracer lifespan (in seconds) | `integer` | `3` |
 | m_render_maxtraces_set | Sets maximum amount of bullet tracers allowed | `integer` | `1000` |
 | m_render_toggle_antiblind | Toggles anti ULX blind | `boolean` | `false` |
 | m_render_toggle_antialert | Toggles anti on screen alerts | `boolean` | `false` |
 | m_render_toggle_fullbright | Toggles fullbright | `boolean` | `false` |
 | m_render_toggle_tracers_beam | Toggles bullet tracer beam effect | `boolean` | `false` |
 | m_render_toggle_tracers_other | Toggles bullet tracers for other people | `boolean` | `false` |
 | m_render_toggle_tracers_local | Toggles bullet tracers for LocalPlayer | `boolean` | `false` |
 | m_render_toggle_bounce | Toggles the attack animation of players | `boolean` | `true` |
 | m_render_toggle_rgb | Toggles rainbow physgun and player | `boolean` | `false` |
</details>
<details>
 <summary>Tool Commands</summary>
 
 Command | Description | Argument(s) | Default |
 | --- | --- | --- | --- |
 | m_tools_gestureloop_set | Sets gesture for gestureloop | `string` | `Dance` |
 | m_tools_psay_message_set | Sets message for ULX psay spammer | `string` | `message` |
 | m_tools_os_set | Sets the OS that will be spoofed | `string—(Windows, Linux, OSX, BSD, POSIX, Other)` | OS at load time |
 | m_tools_toggle_gestureloop | Toggles gestureloop | `boolean` | `false` |
 | m_tools_toggle_psay | Toggles ULX psay spammer | `boolean` | `false` |
 | m_tools_toggle_guiopenurl | Toggles gui.OpenURL detour | `boolean` | `true` |
 | m_tools_toggle_antigag | Toggles anti ULX gag | `boolean` | `false` |
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
