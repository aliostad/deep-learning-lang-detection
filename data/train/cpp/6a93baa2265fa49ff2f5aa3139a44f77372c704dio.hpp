// Copyright 2015 Markus Dittrich. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// mcellGUI is a simulation GUI for MCell (www.mcell.org)

#ifndef IO_HPP
#define IO_HPP

class MolModel;
class ParamModel;
class ReactTreeModel;
class NotificationsModel;
class WarningsModel;
class QTextStream;

bool writeMDL(QString fileName, const MolModel* molModel,
  const ParamModel* paramModel, const NotificationsModel* noteModel,
  const WarningsModel* warnModel, const ReactTreeModel* reactModel);

void writeParams(QTextStream& out, const ParamModel* paramModel);
void writeNotifications(QTextStream& out, const NotificationsModel* noteModel);
void writeWarnings(QTextStream& out, const WarningsModel* noteModel);
void writeMolecules(QTextStream& out, const MolModel* molModel);
//void writeReactions(QTextStream& out, const ReactionModel* reactModel);

#endif
