GtkMainWindow subclass: GtkSUnit [
    | model resultModel set finderTree resultArray resultTree classBrowserWidget searchEntry |

    createFileMenus [
        <category: 'user interface'>

        ^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'New workspace' connectTo: self selector: #newWorkspace.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Open' connectTo: self selector: #open.
            GTK.GtkMenuItem menuItem: 'Save' connectTo: self selector: #saveImage.
            GTK.GtkMenuItem menuItem: 'Save as...' connectTo: self selector: #saveImageAs.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Print' connectTo: self selector: #print.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Save image' connectTo: self selector: #saveImage.
            GTK.GtkMenuItem menuItem: 'Save image as...' connectTo: self selector: #saveImageAs.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Quit' connectTo: self selector: #quit}
    ]

    createEditMenus [
        <category: 'user interface'>

        ^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'Cut' connectTo: self selector: #cut.
            GTK.GtkMenuItem menuItem: 'Copy' connectTo: self selector: #copy.
            GTK.GtkMenuItem menuItem: 'Paste' connectTo: self selector: #paste.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Select all' connectTo: self selector: #selectAll.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Search' connectTo: self selector: #searchClassOrMethod}
    ]

    createToolsMenus [
        <category: 'user interface'>

        ^ self createNewMenuEntry:
            {GTK.GtkMenuItem menuItem: 'Browser' connectTo: self selector: #classBrowser.
            GTK.GtkMenuItem menuItem: 'Browser window' connectTo: self selector: #classBrowserInAWindow.
            GTK.GtkMenuItem menuItem: 'Workspace' connectTo: self selector: #workspace.
            GTK.GtkMenuItem menuItem: 'Inspector' connectTo: self selector: #gtkInspector.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'SqueakZilla' connectTo: self selector: #squeakzilla}
    ]

    createHelpMenus [
        <category: 'user interface'>

        ^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'About Smalltalk Implementor' connectTo: self selector: #aboutImplementor.
            GTK.GtkMenuItem menuItem: 'About GNU Smalltalk' connectTo: self selector: #aboutGst}
    ]

    createMenus [
        <category: 'user interface'>

        self addMenuItem: 'File' withSubmenu: self createFileMenus.
        self addMenuItem: 'Edit' withSubmenu: self createEditMenus.
        self addMenuItem: 'Tools' withSubmenu: self createToolsMenus.
        self addMenuItem: 'Help' withSubmenu: self createHelpMenus
    ]


    createStatusBar [
        <category: 'user interface'>

        self statusMessage: 'SUnit'
    ]

    createToolbar [
        <category: 'user interface'>

	| temp |
        self
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-new');
            appendSeparator;
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-save');
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-save-as');
            appendSeparator;
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-cut');
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-copy');
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-paste');
            appendSeparator;
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-execute');
	    appendSeparator.
	    temp := (GTK.GtkToolItem new)
                        add: (GTK.GtkEntry new);
                        yourself.
            self toolBar insert: temp pos: -1

    ]

    buildFinderEntry [
	<category: 'user interface'>

	searchEntry := GTK.GtkEntry new.
	^ (GTK.GtkHBox new: true spacing: 3)
	    add: (GTK.GtkLabel new: 'Class or method :');
	    add: searchEntry;
	    yourself
    ]

    model [
	<category: 'model accessing'>

	^ model ifNil: [
	    model := GtkImageModel currentModel ]
    ]

    resultModel [
        <category: 'model accessing'>

        ^ resultModel ifNil: [
            resultModel := GTK.GtkTreeStore new: 1 varargs: {GTK.GValue gTypeString} ]
    ]

    buildClassAndMethodList [
	<category: 'user interface'>

	finderTree := GTK.GtkTreeView newWithSortedTextColumn: self model title: 'Methods and Classes'.
	GtkImageModel current isSorted ifFalse: [
	    (finderTree getColumn: 0) signalEmitByName: 'clicked' args: {}.
	    GtkImageModel current isSorted: true ].
	finderTree
	    getSelection
		connectSignal: 'changed' to: self selector: #elementSelected userData: nil.
        ^ GTK.GtkScrolledWindow withChild: finderTree
    ]

    buildFinderList [
	<category: 'user interface'>

	^ GTK.GtkVPaned new
            add1: self buildFinderEntry;
            add2: self buildClassAndMethodList;
            yourself
    ]

    buildResultList [
        <category: 'user interface'>

	resultTree := GTK.GtkTreeView newWithSortedTextColumn: self resultModel title: 'Methods and Classes'.
	(resultTree getColumn: 0) signalEmitByName: 'clicked' args: {}.
        resultTree
            getSelection
                connectSignal: 'changed' to: self selector: #resultSelected userData: nil.
        ^ GTK.GtkScrolledWindow withChild: resultTree
    ]

    buildResultAndClassBrowser [
	<category: 'user interface'>

        ^ GTK.GtkVPaned new
            add1: self buildResultList;
            add2: ((classBrowserWidget := GtkClassBrowserWidget new)
                        initialize;
                        mainWidget);
            yourself
    ]

    buildCentralWidget [
        <category: 'intialize-release'>

	^ (GTK.GtkHPaned new)
	    add1: self buildFinderList;
	    add2: self buildResultAndClassBrowser;
	    yourself
    ]

    initialize [
        <category: 'initialization'>

        super initialize.
        self
            title: 'SUnit';
            createMenus;
            createToolbar;
            createStatusBar;
            centralWidget: self buildCentralWidget.
	finderTree setSearchEntry: searchEntry
    ]

    aboutImplementor [
        <category: 'events'>

        (GTK.GtkAboutDialog new)
            setVersion: VisualGST version;
            setLicense: 'Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.';
            setWebsite: VisualGST website;
            setComments: 'This is a GTK+ wrapper for GNU Smalltalk.';
            "setAuthors: {'Gwenael Casaccio'. 'Nicolas Petton'};"
            setProgramName: 'GNU Smalltalk Implementor';
            run
    ]

    hasSelectedElement [
	<category: 'testing'>

	^ finderTree getSelection getSelected isNil not
    ]

    elementSelected [
	<category: 'events'>

	| iter string |
        (iter := finderTree getSelection getSelected) ifNil: [ ^ self ].
        string := (self model getOop: iter column: 0).
   
	self resultModel clear. 
	resultArray := GtkImageModel current selectedItem: iter.
	resultArray keysDo: [ :each |
	    iter := GTK.GtkTreeIter new.
	    self resultModel append: iter parent: nil.
	    self resultModel setOop: iter column: 0 value: each ].
	resultTree getSelection	selectPath: GTK.GtkTreePath newFirst
    ]

    resultSelected [
	<category: 'events'>

	| selectedIter selectedString |
	(selectedIter := resultTree getSelection getSelected) ifNil: [ ^ self ].
	selectedString := (self resultModel getOop: selectedIter column: 0).

	(resultArray at: selectedString) updateBrowser: classBrowserWidget.
    ]
]
