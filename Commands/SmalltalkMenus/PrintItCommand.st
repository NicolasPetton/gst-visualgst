DoItCommand subclass: PrintItCommand [

    item [
        <category: 'menu item'>

        ^ 'Print It'
    ]

    accel [
        <category: 'menu item'>

	^ '<Control>P'
    ]

    execute [
        <category: 'command'>

        target printIt: target targetObject
    ]
]

