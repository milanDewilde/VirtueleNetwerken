# Checklist voor het resetten van een router/switch
  1. With your router powered off, connect the power cord to the router, and plug the power cord into your power source.
  2. Connect your laptop to the console port on your router with the console cable.
  3. Power on the router and wait 5 to 10 minutes for the router to finish booting. You can check the lights on the router — when the lights are solid or blink in repeating patterns, the router is finished booting.
  4. On your laptop, start the terminal emulator program and use it to access your router’s command line interface (CLI).
  5. In the router CLI, enter the commands in boldface to erase the existing configuration on your router and reload the factory-default configuration on the router: 
     ```
     router> enable
     router# write erase
     Erasing the nvram filesystem will remove all configuration files! Continue? [confirm] <Press Enter key>
     router# reload
     Proceed with reload? [confirm] <Press Enter key>
     -OR-
     Would you like to enter the initial configuration dialog? [yes|no] no <Press Enter key>
     –OR–
     Do you want to save the configuration of the AP? [yes|no] no <Press Enter key>
     ```
  6. Wait until the reload or erase finishes and a CLI prompt or completion message appears.
  7. Close the terminal emulator window on your laptop.
  8. Power off the router.
