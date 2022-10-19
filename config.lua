Config = {
    Radius = 1.5, -- Interact Radius
    ATM = { --Just use if SinglePosition is true
        vector3(146.1194, -1035.1981, 29.3447),
        -- vector3(0,0,0)
    },
    SinglePosition = false, --If you want to use single position, set this to true
    Banks = {
        vector3(0,0,0),
        vector3(1,1,1)
    },
    ATMModels = { --Just use if AutoDetection is true
        "prop_atm_01",
        "prop_atm_02",
        "prop_atm_03",
        "prop_fleeca_atm",
        "prop_atm_01_tray",
        "prop_atm_02_tray",
        "prop_atm_03_tray",
        "prop_fleeca_atm_tray",
    }, 
    AutoDetection = true, --If true, it will use the ATMModels table to detect the atm
}