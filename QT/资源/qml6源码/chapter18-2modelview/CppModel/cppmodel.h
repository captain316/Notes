#ifndef CPPMODEL_H
#define CPPMODEL_H

#include <QtCore>
#include <QtGui>

class CppModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
public:
    enum RoleNames {
        NameRole = Qt::UserRole,
        HueRole = Qt::UserRole+2,
        SaturationRole = Qt::UserRole+3,
        BrightnessRole = Qt::UserRole+4
    };

    explicit CppModel(QObject *parent=0);
    int count() const;

    Q_INVOKABLE void insert(int index,const QString& colorValue);
    Q_INVOKABLE void append(const QString& colorValue);
    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE void clear();
    Q_INVOKABLE QColor get(int index);
signals:
    void countChanged(int arg);
private:
    QList<QColor> m_data;
    QHash<int, QByteArray> m_roleNames;
    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;

    // QAbstractItemModel interface
public:
    QHash<int, QByteArray> roleNames() const override;
};

#endif // CPPMODEL_H
