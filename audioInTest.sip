set_global_assignment -entity "audioInTest" -library "lib_audioInTest" -name IP_TOOL_NAME "clocked_audio_input"
set_global_assignment -entity "audioInTest" -library "lib_audioInTest" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "audioInTest" -library "lib_audioInTest" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_audioInTest" -name SPD_FILE [file join $::quartus(sip_path) "audioInTest.spd"]

set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/audioInTest.vhd"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/mentor/cai_avalon.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/mentor/cai_registers.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/mentor/altera_cai_reset_synchronizer.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/mentor/clocked_audio_input.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/aldec/cai_avalon.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/aldec/cai_registers.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/aldec/altera_cai_reset_synchronizer.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/aldec/clocked_audio_input.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/cadence/cai_avalon.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/cadence/cai_registers.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/cadence/altera_cai_reset_synchronizer.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/cadence/clocked_audio_input.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/synopsys/cai_avalon.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/synopsys/cai_registers.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/synopsys/altera_cai_reset_synchronizer.v"]
set_global_assignment -library "lib_audioInTest" -name MISC_FILE [file join $::quartus(sip_path) "audioInTest_sim/clocked_audio_input/synopsys/clocked_audio_input.v"]
