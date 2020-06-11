{
  "targets": [
    {
      "target_name": "libINCHIAPI",
      "type": "static_library",
      'conditions': [
        ['OS=="mac"',
          {
            'xcode_settings': {
              'OTHER_CFLAGS': [ '-w' ] # disable warnings
            }
          }
        ],
        ['OS=="linux"',
          {
            'cflags': [
              '-w',
              '-fexceptions'
            ]
          }
        ]
      ],
      "direct_dependent_settings": {
        'include_dirs': [
           "INCHI-1-API/INCHI_API"
        ]
      },
      "sources": [
      "INCHI-1-API/INCHI_API/inchi_dll/ichi_bns.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichi_io.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichican2.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichicano.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichicans.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichiisot.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichilnct.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichimak2.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichimake.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichimap1.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichimap2.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichimap4.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichinorm.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichiparm.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichiprt1.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichiprt2.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichiprt3.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichiqueu.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichiread.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichiring.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichirvr1.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichirvr2.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichirvr3.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichirvr4.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichirvr5.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichirvr6.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichirvr7.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichisort.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichister.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ichitaut.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ikey_base26.c",
      "INCHI-1-API/INCHI_API/inchi_dll/ikey_dll.c",
      "INCHI-1-API/INCHI_API/inchi_dll/inchi_dll.c",
      "INCHI-1-API/INCHI_API/inchi_dll/inchi_dll_a.c",
      "INCHI-1-API/INCHI_API/inchi_dll/inchi_dll_a2.c",
      "INCHI-1-API/INCHI_API/inchi_dll/inchi_dll_main.c",
      "INCHI-1-API/INCHI_API/inchi_dll/runichi.c",
      "INCHI-1-API/INCHI_API/inchi_dll/sha2.c",
      "INCHI-1-API/INCHI_API/inchi_dll/strutil.c",
      "INCHI-1-API/INCHI_API/inchi_dll/util.c"
      ]
     }
  ]
}