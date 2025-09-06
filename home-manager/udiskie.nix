{ config, pkgs, ... }:
{
    services.udiskie = {
        enable = true;
        #settings = {
        #    program_options = {
    	#        file_manager = "/bin/env bash ${pkgs.nnn}/bin/nnn";
    	#    };
        #};
    };
}
