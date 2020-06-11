/**
 * This file is distributed under the University of Illinois Open Source
 * License. See LICENSE for details.
 *
 * \file LockUnlockPairs
 * \author Markus Kusano
 * 2013-04-01
 *
 * Finds function local std::mutex::lock and std::mutex::unlock calls. Requires
 * alias analysis information to be provided.
 */
#pragma once

#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Module.h"

using namespace llvm;

class LockUnlockPairs {
    public:
        // Sadly it doesn't seem that CallInst and InvokeInst have a parent
        // class with enough functionality to perform mutations.
        struct CallCallLockPair {
            CallInst *lockCall;
            CallInst *unlockCall;
        };
        struct CallInvokeLockPair {
            CallInst *lockCall;
            InvokeInst *unlockInvoke;
        };
        struct InvokeInvokeLockPair {
            InvokeInst *lockInvoke;
            InvokeInst *unlockInvoke;
        };
        struct InvokeCallLockPair {
            InvokeInst *lockInvoke;
            CallInst *unlockCall;
        };

        /// Finds lock unlock pairs for the passed module using the passed
        /// AliasAnalysis for find pairs.
        void enumerate(Module &M, AliasAnalysis &AA);

        /// returns the total number of pairs found
        unsigned getNumPairs() const;

        unsigned getNumCallCallPairs() const;
        unsigned getNumCallInvokePairs() const;
        unsigned getNumInvokeCallPairs() const;
        unsigned getNumInvokeInvokePairs() const;

        /// Prints debug information to stderr
        void printDebugInfo() const;

        /// Calculates the distance between inst1 and inst2. They are required
	/// to be in the same function. Returns -1 on failure, otherwise the
	/// positive distance between the two instructions.
	int calcDistanceBetween(Instruction *inst1, Instruction *inst2) const;

        // Obtains the callcall pair, or null if index is out of bounds
        CallCallLockPair *getCallCallPair(unsigned index);
        CallInvokeLockPair *getCallInvokePair(unsigned index);
        InvokeCallLockPair *getInvokeCallPair(unsigned index);
        InvokeInvokeLockPair *getInvokeInvokePair(unsigned index);


    private:
        // Returns true if the func is a lock or unlock call to either
        // std::mutex to pthread_mutex_t (ie it is a function call we are
        // interested in). 
        bool isMatch(Function *funcName);

        // Finds lock-unlock CallInst pairs using the passed alias analysis
        // information to match up parameters. They are added to the internal
        // CallPairs vector
        //void findCallPairs(std::vector<CallInst *> &calls, AliasAnalysis &AA);

        // Finds lock-unlock InvokeInst pairs using the passed alias analysis
        // information to match up parameters. They are added to the internal
        // InvokePairs vector.
        //void findInvokePairs(std::vector<InvokeInst *> &calls, AliasAnalysis &AA);

        void findPairs(std::vector<CallInst *> &calls, std::vector<InvokeInst *> &invokes, 
                AliasAnalysis &AA);

        // Checks if the passed otherFunc is a matching unlock call to
        // lockFunc. It is a match if otherFunc is an unlock call, is from the
        // same lock class (POSIX or std::mutex) and they alias to the same
        // lock. The passed alias analysis information is used to determine if
        // the mutexes alias.
        bool isLockUnlockPair(Function *lockFunc, Function *otherFunc, AliasAnalysis &AA, Value *mut1, Value *mut2);
        bool isLockUnlockPair(CallInst *lockCall, CallInst *otherCall, AliasAnalysis &AA);
        bool isLockUnlockPair(CallInst *lockCall, InvokeInst *otherInvoke, AliasAnalysis &AA);
        bool isLockUnlockPair(InvokeInst *lockCall, InvokeInst *otherCall, AliasAnalysis &AA);
        bool isLockUnlockPair(InvokeInst *lockInvoke, CallInst *otherCall, AliasAnalysis &AA);

        // Returns true if the passed function is to pthread_mutex_lock or
        // std::__1::mutex::lock.
        bool isLockCall(Function *func) const;

        // Prints the filename, linenumber and distance between the two
        // instructions.
        void printDebugInfo(Instruction *lockCall, Instruction *unlockCall) const;

        // Vector of pairs of CallInsts to lock/unlock calls
        std::vector<CallCallLockPair *> CallCallPairs;
        std::vector<CallInvokeLockPair *> CallInvokePairs;
        std::vector<InvokeCallLockPair *> InvokeCallPairs;
        std::vector<InvokeInvokeLockPair *> InvokeInvokePairs;
};
