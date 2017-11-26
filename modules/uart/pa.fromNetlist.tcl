
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name uart -dir "C:/work/cpu/uart/planAhead_run_3" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/work/cpu/uart/uart.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/work/cpu/uart} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "uart.ucf" [current_fileset -constrset]
add_files [list {uart.ucf}] -fileset [get_property constrset [current_run]]
link_design
