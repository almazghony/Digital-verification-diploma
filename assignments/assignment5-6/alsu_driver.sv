package alsu_driver_pkg;
    import uvm_pkg::*;
    import item_pkg::*;
    `include "uvm_macros.svh"
  
    class alsu_driver extends uvm_driver #(alsu_item);
        `uvm_component_utils(alsu_driver);
        virtual alsu_if vif;
        alsu_item driver_item;
        function new(string name = "alsu_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                driver_item = alsu_item::type_id::create("driver_item");
                seq_item_port.get_next_item(driver_item);
                vif.A = driver_item.A;
                vif.B = driver_item.B;
                vif.cin = driver_item.cin;
                vif.serial_in = driver_item.serial_in;
                vif.red_op_A = driver_item.red_op_A;
                vif.red_op_B = driver_item.red_op_B;
                vif.opcode = driver_item.opcode;
                vif.bypass_A = driver_item.bypass_A;
                vif.bypass_B = driver_item.bypass_B;
                vif.direction = driver_item.direction;
                vif.rst = driver_item.rst;
                seq_item_port.item_done();
                @(negedge vif.clk);      
                @(negedge vif.clk);      
                `uvm_info("driver_run_phase", driver_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass
endpackage



