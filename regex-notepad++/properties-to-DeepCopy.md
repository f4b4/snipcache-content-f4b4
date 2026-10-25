Find what:     public .+ (\w+) \{ get; set; \}

Replace with:  copy.\1 = \1;
