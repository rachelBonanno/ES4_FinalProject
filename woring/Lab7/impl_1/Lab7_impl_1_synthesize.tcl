if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "Z:/Lab7"
# synthesize IPs
# synthesize VMs
# synthesize top design
file delete -force -- Lab7_impl_1.vm Lab7_impl_1.ldc
run_engine_newmsg synthesis -f "Lab7_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o Lab7_impl_1_syn.udb Lab7_impl_1.vm] "Z:/Lab7/impl_1/Lab7_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
