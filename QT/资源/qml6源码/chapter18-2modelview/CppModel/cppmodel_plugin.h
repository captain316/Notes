#ifndef CPPMODEL_PLUGIN_H
#define CPPMODEL_PLUGIN_H

#include <QQmlExtensionPlugin>

class CppModelPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    void registerTypes(const char *uri) override;
};

#endif // CPPMODEL_PLUGIN_H
