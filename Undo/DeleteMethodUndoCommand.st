UndoCommand subclass: DeleteMethodUndoCommand [

    | selector classOrMeta compiledMethod treeStore |

    DeleteMethodUndoCommand class >> delete: aSymbol in: aClass onModel: aGtkMethodModel [
	<category: 'instance creation'>

	^ (self new)
	    delete: aSymbol in: aClass onModel: aGtkMethodModel;
	    precondition;
	    yourself
    ]

    delete: aSymbol in: aClass onModel: aGtkMethodModel [
	<category: 'initialize'>

	selector := aSymbol.
	classOrMeta := aClass.
	treeStore := aGtkMethodModel
    ]

    description [
	<category: 'accessing'>

	^ 'Delete a method'
    ]

    precondition [
        <category: 'checking'>

    ]

    undo [
	<category: 'events'>

	classOrMeta methodDictionary at: selector put: compiledMethod.
	treeStore appendMethod: selector asString
    ]

    redo [
	<category: 'events'>

	compiledMethod := classOrMeta >> selector.
	classOrMeta methodDictionary removeKey: selector.
	treeStore removeMethod: selector asString
    ]
]
