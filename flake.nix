{
  description = "A collection of flake templates";

  outputs =
    { self }:
    {

      templates = {

        Python = {
          path = ./Python;
          description = "Python template";
        };

        Rust = {
          path = ./Rust;
          description = "Rust template";
        };

        NodeJS = {
          path = ./NodeJS;
          description = "NodeJS template";
        };

        "C++" = {
          path = ./C++;
          description = "C++ template";
        };
      };
    };
}
