package sr_driver_pkg;
    import sr_config_pkg::*;
    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh";
    
    class sr_driver extends uvm_driver #(sr_seq_item);
        `uvm_component_utils(sr_driver);
        
        virtual sr_if vif;
        sr_config driver_cfg;
        sr_seq_item driver_item;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                driver_item = sr_seq_item::type_id::create("driver_item");
                seq_item_port.get_next_item(driver_item);
                vif.serial_in = driver_item.serial_in;
                vif.direction = driver_item.direction;
                vif.mode = driver_item.mode;
                vif.datain = driver_item.datain;
                #2;
                seq_item_port.item_done();
                `uvm_info("run_phase", driver_item.convert2string_stimulus(), UVM_HIGH);
            end
        endtask
    endclass
endpackage