import psutil
print('openssl_is_running{} ',end="")
for proc in psutil.process_iter():
   try:
       name = proc.name()
       if(name == "openssl"):
           command = proc.cmdline()
           if("qatengine" in command):
               if("-multi" in command):
                  print(4)
               else:
                  print(2)
               break
           elif("-multi" in command):
               print(3)
               break
           else:
               print(1)
               break
   except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
       pass
else:
   print(0)