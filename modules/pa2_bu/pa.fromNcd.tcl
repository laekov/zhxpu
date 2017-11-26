
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name pa2 -dir "C:/work/cpu/pa2/planAhead_run_4" -part xc3s1200efg320-4
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "C:/work/cpu/pa2/ramController.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/work/cpu/pa2} }
set_property target_constrs_file "ramController.ucf" [current_fileset -constrset]
add_files [list {ramController.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "C:/work/cpu/pa2/ramController.ncd"
if {[catch {read_twx -name results_1 -file "C:/work/cpu/pa2/ramController.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"C:/work/cpu/pa2/ramController.twx\": $eInfo"
}
