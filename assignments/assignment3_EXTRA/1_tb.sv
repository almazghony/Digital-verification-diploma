module tb1();

    int j;
    int q[$];

    initial begin
        j = 1;
        q = '{0, 2, 5};
        q.insert(1, j);
        $display("q = %p", q);
        q.delete(1);
        $display("q = %p", q);
        q.push_front(7);
        $display("q = %p", q);
        q.push_back(9);
        $display("q = %p", q);
        j = q.pop_front();
        $display("q = %p, j = %0d", q, j);
        j = q.pop_back();
        $display("q = %p, j = %0d", q, j);
        q.reverse();
        $display("reverse q = %p", q);
        q.sort();
        $display("sort q = %p", q);
        q.rsort();
        $display("rsort q = %p", q);
        q.shuffle();
        $display("shuffle q = %p" , q);
        
    end
endmodule
