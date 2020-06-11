using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bacnet_Test_Final
{
    
         class TsmProcessor
    { 

    
       static node[] invoke_id_array;
       static byte pos;
  
         static TsmProcessor()
       {
           invoke_id_array = new node[255];
            for(int i=0;i<255;i++)
            {
                invoke_id_array[i].id=0;

            }
           pos = 0;
       }
        internal static byte next_free_id(UInt32 temp)
         {
             byte now = pos;
             pos++;
            while(pos!=now)
            {
                if (invoke_id_array[pos].id == 0)
                {
                    invoke_id_array[pos].id = 1;
                    invoke_id_array[pos].device_id = temp;
                    return pos;

                }
                else 
                    pos++;
                if(pos==100)
                {
                    pos = 0;
                }
            }
            return 255; //代表错误
        }
        internal static void free_invoke_id(Byte id)
        {
            invoke_id_array[pos].id = 0;

        }
        internal static UInt32 Get_Device_Id(Byte invoke_id)
        {
            if (invoke_id_array[invoke_id].id == 1)
                return invoke_id_array[invoke_id].device_id;
            else
                return 0;
        }
      struct node
      {
          public int id;
          public UInt32 device_id;
      }
    }

}
