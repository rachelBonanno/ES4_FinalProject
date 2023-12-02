if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "C:/Users/rbonan02/Desktop/workingcolorbackground12_2_1456"
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- workingcolorbackroung_impl_1_cpe.ldc
run_engine_newmsg cpe -f "workingcolorbackroung_impl_1.cprj" "mypll.cprj" -a "iCE40UP"  -o workingcolorbackroung_impl_1_cpe.ldc
# synthesize top design
file delete -force -- workingcolorbackroung_impl_1.vm workingcolorbackroung_impl_1.ldc
run_engine_newmsg synthesis -f "workingcolorbackroung_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o workingcolorbackroung_impl_1_syn.udb workingcolorbackroung_impl_1.vm] "C:/Users/rbonan02/Desktop/workingcolorbackground12_2_1456/impl_1/workingcolorbackroung_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
