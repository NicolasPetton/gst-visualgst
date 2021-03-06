Object subclass: MenuBuilder [

    | commands target |

    MenuBuilder class >> on: aGtkBrowser [
        <category: 'menu-building'>

        ^self new target: aGtkBrowser; connect; yourself
    ]

    MenuBuilder class >> browserBuildOn: aGtkBrowser [
        <category: 'menu-building'>

        ^ (self on: aGtkBrowser) asMenuItems
    ]

    asPopupMenu [
        | menu |
        menu := GTK.GtkMenu new.
        self appendTo: menu.
        ^ menu
    ]

    asMenuItems [
        | menu |
        ^commands collect: [ :each || item accelPath |
            item := each buildMenuItem.
            each accel isNil ifFalse: [
                accelPath := target accelPath, '/', each class name.
                target accelGroup append: {{each accel. accelPath}}.
                item setAccelPath: accelPath ].
            item ].
    ]

    appendTo: aGtkMenu [
        commands do: [ :each || item |
            item := each buildMenuItem.
            each setState: item.
            aGtkMenu append: item ]
    ]

    target [
        ^target
    ]

    target: anObject [
        target := anObject.
    ]

    connect [
        commands := self class menus collect: [ :each | each on: self target ]
    ]
]

