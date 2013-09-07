module lib.utils;

import std.stdio;

void trace(T)(T obj) nothrow {
    try{
        writeln(obj);
    } catch {

    }
}
