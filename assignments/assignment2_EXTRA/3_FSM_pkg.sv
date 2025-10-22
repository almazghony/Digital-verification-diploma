
package FSM_pkg;
    class fsm_transaction;
        rand logic x;
        rand logic rst;

        constraint c1 {
            rst dist {1 := 1, 0 := 90};
            x dist   {0 := 67, 1:= (100 - 67)};
        }
    endclass
endpackage

