namespace ozulis
{
  inline void
  Compiler::enableAstDump(bool enable)
  {
    astDumpParser_ = enable;
    astDumpScopeBuilder_ = enable;
    astDumpTypeChecker_ = enable;
    astDumpSimplify_ = enable;
  }

  inline void
  Compiler::enableAstDumpParser(bool enable)
  {
    astDumpParser_ = enable;
  }

  inline void
  Compiler::enableAstDumpScopeBuilder(bool enable)
  {
    astDumpScopeBuilder_ = enable;
  }

  inline void
  Compiler::enableAstDumpTypeChecker(bool enable)
  {
    astDumpTypeChecker_ = enable;
  }

  inline void
  Compiler::enableAstDumpSimplify(bool enable)
  {
    astDumpSimplify_ = enable;
  }

  inline const TargetData &
  Compiler::targetData() const
  {
    return *targetData_;
  }
}
