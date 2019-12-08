/*  -*- Mode: C; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */

/**

    @file       confini.h
    @brief      libconfini header
    @author     Stefano Gioffr&eacute;
    @copyright  GNU Public License version 3 or any later version
    @date       2016-2019
    @see        https://github.com/madmurphy/libconfini/

**/

import core.stdc.config;
import core.stdc.stdio;

extern (C):

/*  PRIVATE (HEADER-SCOPED) MACROS  */

/*  PUBLIC MACROS  */

/**
    @brief  Calls a user-given macro for each row of the table
**/
/*
    NOTE: The following table and the order of its rows **define** (and link
    together) both the #IniFormat and #IniFormatNum data types declared in this
    header
*/
/*  IniFormat table  *\

NAME                      BIT  SIZE DEFAULT
                                                              */

/*
*/

/*
*/

/**
    @brief  Checks whether a format does **not** support escape sequences
**/
extern (D) auto INIFORMAT_HAS_NO_ESC(T)(auto ref T FORMAT)
{
    return FORMAT.multiline_nodes == IniMultiline.INI_NO_MULTILINE && FORMAT.no_double_quotes && FORMAT.no_single_quotes;
}

/*  PUBLIC TYPEDEFS  */

/**
    @brief  24-bit bitfield representing the format of an INI file (INI
            dialect)
**/
struct IniFormat
{
    import std.bitmanip : bitfields;

    mixin(bitfields!(
        ubyte, "delimiter_symbol", 7,
        ubyte, "case_sensitive", 1,
        ubyte, "semicolon_marker", 2,
        ubyte, "hash_marker", 2,
        ubyte, "section_paths", 2,
        ubyte, "multiline_nodes", 2,
        ubyte, "no_single_quotes", 1,
        ubyte, "no_double_quotes", 1,
        ubyte, "no_spaces_in_names", 1,
        ubyte, "implicit_is_not_empty", 1,
        ubyte, "do_not_collapse_values", 1,
        ubyte, "preserve_empty_quotes", 1,
        ubyte, "disabled_after_space", 1,
        ubyte, "disabled_can_be_implicit", 1,
        uint, "", 8));
}

/**
    @brief  Global statistics about an INI file
**/
struct IniStatistics
{
    const IniFormat format;
    const size_t bytes;
    const size_t members;
}

/**
    @brief  Dispatch of a single INI node
**/
struct IniDispatch
{
    const IniFormat format;
    ubyte type;
    char* data;
    char* value;
    const(char)* append_to;
    size_t d_len;
    size_t v_len;
    size_t at_len;
    size_t dispatch_id;
}

/**
    @brief  The unique ID of an INI format (24-bit maximum)
**/
alias IniFormatNum = uint;

/**
    @brief  Callback function for handling an #IniStatistics structure
**/
alias IniStatsHandler = int function (
    IniStatistics* statistics,
    void* user_data);

/**
    @brief  Callback function for handling an #IniDispatch structure
**/
alias IniDispHandler = int function (IniDispatch* dispatch, void* user_data);

/**
    @brief  Callback function for handling an INI string belonging to a
            sequence of INI strings
**/
alias IniStrHandler = int function (
    char* ini_string,
    size_t string_length,
    size_t string_num,
    IniFormat format,
    void* user_data);

/**
    @brief  Callback function for handling a selected fragment of an INI string
**/
alias IniSubstrHandler = int function (
    const(char)* ini_string,
    size_t fragm_offset,
    size_t fragm_length,
    size_t fragm_num,
    IniFormat format,
    void* user_data);

/*  PUBLIC FUNCTIONS  */

int strip_ini_cache (
    char* ini_source,
    const size_t ini_length,
    const IniFormat format,
    const IniStatsHandler f_init,
    const IniDispHandler f_foreach,
    void* user_data);

int load_ini_file (
    FILE* ini_file,
    const IniFormat format,
    const IniStatsHandler f_init,
    const IniDispHandler f_foreach,
    void* user_data);

int load_ini_path (
    const char* path,
    const IniFormat format,
    const IniStatsHandler f_init,
    const IniDispHandler f_foreach,
    void* user_data);

bool ini_string_match_ss (
    const char* simple_string_a,
    const char* simple_string_b,
    const IniFormat format);

bool ini_string_match_si (
    const char* simple_string,
    const char* ini_string,
    const IniFormat format);

bool ini_string_match_ii (
    const char* ini_string_a,
    const char* ini_string_b,
    const IniFormat format);

bool ini_array_match (
    const char* ini_string_a,
    const char* ini_string_b,
    const char delimiter,
    const IniFormat format);

size_t ini_unquote (char* ini_string, const IniFormat format);

size_t ini_string_parse (char* ini_string, const IniFormat format);

size_t ini_array_get_length (
    const char* ini_string,
    const char delimiter,
    const IniFormat format);

int ini_array_foreach (
    const char* ini_string,
    const char delimiter,
    const IniFormat format,
    const IniSubstrHandler f_foreach,
    void* user_data);

size_t ini_array_shift (
    const char** ini_strptr,
    const char delimiter,
    const IniFormat format);

size_t ini_array_collapse (
    char* ini_string,
    const char delimiter,
    const IniFormat format);

char* ini_array_break (
    char* ini_string,
    const char delimiter,
    const IniFormat format);

char* ini_array_release (
    char** ini_strptr,
    const char delimiter,
    const IniFormat format);

int ini_array_split (
    char* ini_string,
    const char delimiter,
    const IniFormat format,
    const IniStrHandler f_foreach,
    void* user_data);

void ini_global_set_lowercase_mode (bool lowercase);

void ini_global_set_implicit_value (
    char* implicit_value,
    const size_t implicit_v_len);

IniFormatNum ini_fton (const IniFormat format);

IniFormat ini_ntof (IniFormatNum format_id);

int ini_get_bool (const char* ini_string, const int return_value);

/*  PUBLIC LINKS  */

extern __gshared const int function (const(char)* ini_string) ini_get_int;

extern __gshared const c_long function (const(char)* ini_string) ini_get_lint;

extern __gshared const long function (const(char)* ini_string) ini_get_llint;

extern __gshared const double function (
    const(char)* ini_string) ini_get_double;

/**
    @brief  Legacy support, soon to be replaced with a `float` data type --
            please **do not use `ini_get_float()`!**
**/

/*  PUBLIC CONSTANTS AND VARIABLES  */

/**
    @brief  Error mask (flags not present in user-generated interruptions)
**/
enum CONFINI_ERROR = 252;

/**
    @brief  Error codes
**/
enum ConfiniInterruptNo
{
    CONFINI_SUCCESS = 0, /**< There have been no interruptions, everything
         went well [value=0] **/
    CONFINI_IINTR = 1, /**< Interrupted by the user during `f_init()`
         [value=1] **/
    CONFINI_FEINTR = 2, /**< Interrupted by the user during `f_foreach()`
         [value=2] **/
    CONFINI_ENOENT = 4, /**< File inaccessible [value=4] **/
    CONFINI_ENOMEM = 5, /**< Error allocating virtual memory [value=5] **/
    CONFINI_EIO = 6, /**< Error reading the file [value=6] **/
    CONFINI_EOOR = 7, /**< Out-of-range error: callbacks are more than
         expected [value=7] **/
    CONFINI_EBADF = 8, /**< The stream specified is not a seekable stream
         [value=8] **/
    CONFINI_EFBIG = 9 /**< File too large [value=9] **/
}

/**
    @brief  INI node types
**/
enum IniNodeType
{
    INI_UNKNOWN = 0, /**< This is a node impossible to categorize
         [value=0] **/
    INI_VALUE = 1, /**< Not used by **libconfini** (values are
         dispatched together with keys) -- but
         available for user's implementations
         [value=1] **/
    INI_KEY = 2, /**< This is a key [value=2] **/
    INI_SECTION = 3, /**< This is a section or a section path
         [value=3] **/
    INI_COMMENT = 4, /**< This is a comment [value=4] **/
    INI_INLINE_COMMENT = 5, /**< This is an inline comment [value=5] **/
    INI_DISABLED_KEY = 6, /**< This is a disabled key [value=6] **/
    INI_DISABLED_SECTION = 7 /**< This is a disabled section path
         [value=7] **/
}

/**
    @brief  Most used key-value and array delimiters (but a delimiter may also
            be any other ASCII character)
**/
enum IniDelimiters
{
    INI_ANY_SPACE = 0, /**< In multi-line INIs:
         `/(?:\\(?:\n\r?|\r\n?)|[\t \v\f])+/`, in
         non-multi-line INIs: `/[\t \v\f])+/` **/
    INI_EQUALS = '=', /**< Equals character (`=`) **/
    INI_COLON = ':', /**< Colon character (`:`) **/
    INI_DOT = '.', /**< Dot character (`.`) **/
    INI_COMMA = ',' /**< Comma character (`,`) **/
}

/**
    @brief  Possible values of #IniFormat::semicolon_marker and
            #IniFormat::hash_marker (i.e., meaning of `/\s+[#;]/` in respect to
            a format)
**/
enum IniCommentMarker
{
    INI_DISABLED_OR_COMMENT = 0, /**< This marker opens a comment or a
         disabled entry **/
    INI_ONLY_COMMENT = 1, /**< This marker opens a comment **/
    INI_IGNORE = 2, /**< This marker opens a comment that must
         not be dispatched or counted **/
    INI_IS_NOT_A_MARKER = 3 /**< This is not a marker at all, but a
         normal character instead **/
}

/**
    @brief  Possible values of #IniFormat::section_paths
**/
enum IniSectionPaths
{
    INI_ABSOLUTE_AND_RELATIVE = 0, /**< Section paths starting with a dot
         express nesting to the current parent,
         to root otherwise **/
    INI_ABSOLUTE_ONLY = 1, /**< Section paths starting with a dot will
         be cleaned of their leading dot and
         appended to root **/
    INI_ONE_LEVEL_ONLY = 2, /**< Format supports sections, but the dot
         does not express nesting and is not a
         meta-character **/
    INI_NO_SECTIONS = 3 /**< Format does *not* support sections --
         `/\[[^\]]*\]/g`, if any, will be
         treated as keys! **/
}

/**
    @brief  Possible values of #IniFormat::multiline_nodes
**/
enum IniMultiline
{
    INI_MULTILINE_EVERYWHERE = 0, /**< Comments, section paths and keys
         -- disabled or not -- are allowed
         to be multi-line **/
    INI_BUT_COMMENTS = 1, /**< Only section paths and keys --
         disabled or not -- are allowed to
         be multi-line **/
    INI_BUT_DISABLED_AND_COMMENTS = 2, /**< Only active section paths and
         active keys are allowed to be
         multi-line **/
    INI_NO_MULTILINE = 3 /**< Multi-line escape sequences are
         disabled **/
}

/**
    @brief  A model format for standard INI files
**/
extern __gshared const IniFormat INI_DEFAULT_FORMAT;

/**
    @brief  A model format for Unix-like .conf files (where space characters
            are delimiters between keys and values)
**/
/*  All fields are set to `0` here.  */
extern __gshared const IniFormat INI_UNIXLIKE_FORMAT;

/**
    @brief  If set to `true`, key and section names in case-insensitive INI
            formats will be dispatched lowercase, verbatim otherwise (default
            value: `false`)
**/
extern __gshared bool INI_GLOBAL_LOWERCASE_MODE;

/**
    @brief  Value to be assigned to implicit keys (default value: `NULL`)
**/
extern __gshared char* INI_GLOBAL_IMPLICIT_VALUE;

/**
    @brief  Length of the value assigned to implicit keys -- this may be any
            unsigned number, independently of the real length of
            #INI_GLOBAL_IMPLICIT_VALUE (default value: `0`)
**/
extern __gshared size_t INI_GLOBAL_IMPLICIT_V_LEN;

/*  CLEAN THE PRIVATE ENVIRONMENT  */

/*  END OF `_LIBCONFINI_HEADER_`  */

/*  EOF  */
