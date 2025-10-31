package sequence_pkg;
    import shared_pkg::*;
    import item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class reset_sequence extends uvm_sequence #(alsu_item);
        `uvm_object_utils(reset_sequence);

        alsu_item reset_item;

        function new(string name = "reset_sequence");
            super.new(name);
        endfunction

        task body();
            reset_item = alsu_item::type_id::create("reset_item");
            start_item(reset_item);
            reset_item.A = 0;
            reset_item.B = 0;
            reset_item.cin = 0;
            reset_item.serial_in = 0;
            reset_item.red_op_A = 0;
            reset_item.red_op_B = 0;
            reset_item.opcode = OR;
            reset_item.bypass_A = 0;
            reset_item.bypass_B = 0;
            reset_item.rst = 1;
            reset_item.direction = 0;
            reset_item.leds = 0;
            reset_item.out = 0;
            finish_item(reset_item);
        endtask

    endclass


    class main_sequence extends uvm_sequence #(alsu_item);
        `uvm_object_utils(main_sequence);

        alsu_item main_item;

        function new(string name = "main_sequence");
            super.new(name);
        endfunction

        task body();
            
            main_item = alsu_item::type_id::create("main_item");
            main_item.opcode_array_c.constraint_mode(0);
            repeat(50000) begin
                start_item(main_item);
                assert(main_item.randomize());
                finish_item(main_item);
            end

            start_item(main_item);
            main_item.rst = 0;
            main_item.opcode = OR;
            finish_item(main_item);
            start_item(main_item);
            main_item.rst = 0;
            main_item.opcode = XOR;
            finish_item(main_item);

            start_item(main_item);
            main_item.rst = 0;
            main_item.opcode = ADD;
            finish_item(main_item);

            start_item(main_item);
            main_item.rst = 0;
            main_item.opcode = MULT;
            finish_item(main_item);

            start_item(main_item);
            main_item.rst = 0;
            main_item.opcode = SHIFT;
            finish_item(main_item);

            start_item(main_item);
            main_item.rst = 0;
            main_item.opcode = ROTATE;
            finish_item(main_item);

            main_item.constraint_mode(0);
            main_item.opcode_array_c.constraint_mode(1);
            repeat (10000) begin
                assert(main_item.randomize());

                foreach (main_item.opcode_array[j]) begin
                    start_item(main_item);

                    main_item.rst       = 0;
                    main_item.bypass_A  = 0;
                    main_item.bypass_B  = 0;
                    main_item.red_op_A  = 0;
                    main_item.red_op_B  = 0;

                    main_item.opcode    = main_item.opcode_array[j];

                    finish_item(main_item);
                end
            end
        endtask
    endclass
endpackage
