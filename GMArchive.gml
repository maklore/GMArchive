function __GMArchive() {
    
    static library = ds_map_create();
    static book = "";
    static chapter = "";
    static page = 0;
    static line 0;
    return static_get(__GMArchive);
}
__GMArchive();

function GMArchiveAdd() {
    
    static book = function(_book) {
        static get = __GMArchive();
        if !ds_map_exists(get.library, _book) {
            ds_map_add(get.library, _book, ds_map_create());
            get.book = _book;
        } else {
            get.book = _book;
        }
        return self;
    }
    
    static chapter = function(_chapter) {
        static get = __GMArchive();
        if !ds_map_exists(get.library[? get.book], _chapter) {
            ds_map_add(get.library[? get.book], _chapter, []);
            get.chapter = _chapter;
        } else {
            get.chapter = _chapter;
        }
        return self;
    }
    
    static page = function(_page) {
        static get = __GMArchive();
        if !array_exists(get.library[? get.book][? get.chapter][_page]) {
            get.library[? get.book][? get.chapter][_page] = [];
            get.page = _page;
            return true;
        } else {
            get.page = _value;
        }
        return self;
    }
    
    static line = function(_string, _line = undefined) {
        static get = __GMArchive();
        var _array = get.library[? get.book][? get.chapter][get.page];
        if is_undefined(_line) {
            array_push(_array, _string);
        } else {
            array_insert(_array, _line, _string);
        }
        return self;
    }
    
    return static_get(GMArchiveAdd);
}

function GMArchiveRead(_book = undefined, _chapter = undefined, _page = undefined, _line = undefined) {
    static get = __GMArchive();
    if !ds_exist(get.library, ds_type_map) or 
        (!is_undefined(_chapter) and !ds_map_exists(get.library, _chapter)) {
        return -1;
    }
    if !is_undefined(_line) {
        return json_stringify(get.library[? _book][? _chapter][_page][_line], true);
    }
    if !is_undefined(_page) {
        return json_stringify(get.library[? _book][? _chapter][_page], true);
    }
    if !is_undefined(_chapter) {
        return json_stringify(get.library[? _book][? _chapter], true);
    }
    if !is_undefined(_book) {
        return json_encode(get.library[? _book], true);
    }
    return json_encode(get.library, true);
}

function GMArchiveDispose(_book, _chapter = undefined, _page = undefined, _line = undefined) {
    static get = __GMArchive();
    if !ds_exist(get.library, ds_type_map) or 
        (!is_undefined(_chapter) and !ds_map_exists(get.library, _chapter)) {
        return -1;
    }
    if !is_undefined(_line) {
        var _index = array_get_index(get.library[$ _book][$ _chapter][_page], _line);
        array_delete(get.library[? _book][? _chapter][_page], _index, 1);
        return 3;
    }
    if !is_undefined(_page) {
        array_delete(get.library[? _book][? _chapter], _page, 1);
        return 2;
    }
    if !is_undefined(_chapter) {
        var _length = array_length(get.library[? _book][? _chapter])
        array_delete(get.library[? _book][? _chapter], 0, _length - 1);
        return 1;
    }
    ds_map_destroy(get.library[? _book]);
    return 0;
}

function GMArchiveClose() {
    static get = __GMArchive();
    var _map_size ds_map_size(get.library);
    if _map_size > 0 {
        var _key = ds_map_find_first(get.library);
        repeat _map_size {
           ds_map_destroy(get.library[? _key]);
            _key = ds_map_find_next(get.library, _key);
            if is_undefined(_key) {
                break;
            }
        }
    }
    ds_map_destroy(get.library);
}

//EXAMPLE
GMArchiveAdd()
    .book("The Tale of Two Brothers")
        .chapter("Wronged")
            .page(0)
                .line("Fear my wrath brother! For you should never had taken my life's work as your own!")
                .line("Dearest brother... It was not your work I had taken... But our father's dream...")
                .line("I took our father's dream and turned it into reality! You did NOTHING, for decades!")
            .page(1)
                .line("Matters not now... We will earn a fortune and dine as kings, till the end of our days!")
                .line("It mattered to me...")
        .chapter("Fall")
            .page(0)
                .line("I'm sorry... Brother... It had to be done...")
    .book("In a faraway land")
    //etc
