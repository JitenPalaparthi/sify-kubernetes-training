package main

import "testing"

func TestBasic(t *testing.T) {
    if 2+2 != 4 {
        t.Fatal("expected 4")
    }
}
