package shift_reg_driver_pkg;
    import shift_reg_config_pkg::*;
    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh";
    
    class shift_reg_driver extends uvm_driver #(shift_reg_seq_item);
        `uvm_component_utils(shift_reg_driver);
        
        virtual shift_reg_if vif;
        shift_reg_config driver_cfg;
        shift_reg_seq_item driver_item;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
                forever begin
                    driver_item = shift_reg_seq_item::type_id::create("driver_item");
                    seq_item_port.get_next_item(driver_item);
                    vif.reset = driver_item.reset;
                    vif.serial_in = driver_item.serial_in;
                    vif.direction = driver_item.direction;
                    vif.mode = driver_item.mode;
                    vif.datain = driver_item.datain;
                    @(negedge vif.clk);
                    seq_item_port.item_done();
                    `uvm_info("run_phase", driver_item.convert2string_stimulus(), UVM_HIGH);
                end
        endtask
    endclass

endpackage