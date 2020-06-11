#pragma once

#include <cstdint>
#include <iostream>

/** @file */

/**
 * The kind of the dump.
 *
 * Decides what data does the dump contain.
 */
enum class DumpKind : std::uint8_t
{
    /**
     * The default value, a stub-history dump.
     */
    None     = 0x00,
    /**
     * The dump is a pages dump (not a stub dump).
     * That means it contains texts of pages.
     */
    Pages    = 0x01,
    /**
     * The dump is a current dump (not a history dump).
     * That means it contains only the most recent revision for each page.
     */
    Current  = 0x02,
    /**
     * The dump is articles dump.
     * That means it contains only pages from important namespaces
     * (not from the %User namespace ot talk namespaces).
     */
    Articles = 0x04
};

/**
 * Returns whether the given @a dumpKind represents pages dump.
 */
bool IsPages(DumpKind dumpKind);
/**
 * Returns whether the given @a dumpKind represents stub dump.
 */
bool IsStub(DumpKind dumpKind);

/**
 * Returns whether the given @a dumpKind represents current dump.
 */
bool IsCurrent(DumpKind dumpKind);
/**
 * Returns whether the given @a dumpKind represents history dump.
 */
bool IsHistory(DumpKind dumpKind);

/**
 * Returns whether the given @a dumpKind represents articles dump.
 */
bool IsArticles(DumpKind dumpKind);

/**
 * Combines two values of DumpKind together. 
 */
DumpKind operator |(DumpKind first, DumpKind second);
DumpKind operator |=(DumpKind &first, DumpKind second);

/**
 * Writes the given @a dumpKind to the given @a stream in human readable form.
 * The output can be for example @c pages-current-articles.
 */
std::ostream& operator<<(std::ostream& stream, DumpKind dumpKind);