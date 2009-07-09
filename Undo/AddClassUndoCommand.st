UndoCommand subclass: AddUndoClassUndoCommand [

    | first namespace newClassName treeStore parentClass newIter newClass |

    AddUndoClassUndoCommand class >> add: aSymbol to: aNamespace onModel: aGtkClassModel withSuperclass: aClass [
	<category: 'instance creation'>

	^ (self new)
	    add: aSymbol to: aNamespace onModel: aGtkClassModel withSuperclass: aClass;
	    precondition;
	    yourself
    ]

    add: aSymbol to: aNamespace onModel: aGtkClassModel withSuperclass: aClass [
	<category: 'initialize'>

	first := true.
	newClassName := aSymbol.
	namespace := aNamespace.
	treeStore := aGtkClassModel.
	parentClass := aClass
    ]

    description [
	<category: 'accessing'>

	^ 'Add a class'
    ]

    precondition [
	<category: 'checking'>

	newClassName = #Smalltalk ifTrue: [ self error: 'class name can''t be the same has a namespace name'  ].
	Smalltalk subspacesDo: [ :each | each name = newClassName ifTrue: [ self error: 'class name can''t be the same has a namespace name'  ] ].
	(namespace findIndexOrNil: newClassName) ifNotNil: [ self error: 'class exist in the namespace' ]
    ]

    undo [
	<category: 'events'>

	treeStore remove: newClass.
	parentClass removeSubclass: newClass
    ]

    redo [
	<category: 'events'>

	| iter |
	first ifFalse: [
	    (treeStore hasClass: parentClass) 
		ifTrue: [ iter := treeStore findIterInAClass: parentClass ]
		ifFalse: [ iter := nil ].
	    treeStore append: iter column: 0 value: newClassName, ' class'.
	    first := false ].
	newClass := parentClass subclass: newClassName environment: namespace.
	namespace at: newClass name put: newClass
    ]
]
