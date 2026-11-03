{
  description = "Configuracion de NixOS de Andres con Flakes y OpenCode 2.x";

  inputs = {
    # Usamos unstable para las caracteristicas de OpenCode 2.x mas recientes
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      # Reemplaza "nixos" si tu hostname (nombre de tu maquina) es diferente
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Cambia segun tu arquitectura si es necesario
        modules = [
          ./nixos/configuration.nix
          ./nixos/hardware-configuration.nix
        ];
      };
    };
  };
}

