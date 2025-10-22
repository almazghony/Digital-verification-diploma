package seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class shift_reg_seq_item extends uvm_sequence_item;
        `uvm_object_utils(shift_reg_seq_item);
        
        rand logic reset;
        rand logic serial_in, direction, mode;
        rand logic [5:0] datain;
        rand logic [5:0] dataout;

        function new(string name = "shift_reg_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s reset = %0b, serial_in = %0b, direction = %0b, mode = %0b, datain = %0b, dataout = %0b", super.convert2string(), reset, serial_in, direction, mode, datain, dataout);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("reset = %0b, serial_in = %0b, direction = %0b, mode = %0b, datain = %0b", reset, serial_in, direction, mode, datain);
        endfunction

        constraint c1 {
            reset dist {0 := 9, 1:= 1};
        }    
    endclass

endpackage 