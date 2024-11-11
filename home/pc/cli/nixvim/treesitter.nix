_: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        settings = {indent.enable = true;};
      };
      treesitter-textobjects = {
        enable = true;
        extraOptions = {
          select = {
            enable = true;
            lookahead = true;
            keymaps = {
              # You can use the capture groups defined in textobjects.scm
              "aa" = "@parameter.outer";
              "ia" = "@parameter.inner";
              "af" = "@function.outer";
              "if" = "@function.inner";
              "ac" = "@class.outer";
              "ic" = "@class.inner";
              "ii" = "@conditional.inner";
              "ai" = "@conditional.outer";
              "il" = "@loop.inner";
              "al" = "@loop.outer";
              "at" = "@comment.outer";
            };
          };
          move = {
            enable = true;
            set_jumps = true; # whether to set jumps in the jumplist
            goto_next_start = {
              "]f" = "@function.outer";
              "]]" = "@class.outer";
            };
            goto_next_end = {
              "]F" = "@function.outer";
              "][" = "@class.outer";
            };
            goto_previous_start = {
              "[f" = "@function.outer";
              "[[" = "@class.outer";
            };
            goto_previous_end = {
              "[F" = "@function.outer";
              "[]" = "@class.outer";
            };
          };
          swap = {
            enable = true;
            swap_next = {"<leader>a" = "@parameter.inner";};
            swap_previous = {"<leader>A" = "@parameter.inner";};
          };
        };
      };
    };
  };
}
