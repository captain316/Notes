#include "cppmodel.h"

CppModel::CppModel(QObject *parent):QAbstractListModel(parent)
{
    m_roleNames[NameRole]="name";
    m_roleNames[HueRole]="hue";
    m_roleNames[SaturationRole]="saturation";
    m_roleNames[BrightnessRole]="brightness";

//    for(const QString& name:QColor::colorNames()){
//        m_data.append(QColor(name));
//    }
}

int CppModel::count() const
{
    return rowCount(QModelIndex());
}

void CppModel::insert(int index, const QString &colorValue)
{
    if(index<0||index>m_data.count()) return;

    QColor color(colorValue);

    if(!color.isValid()) return;

    emit beginInsertRows(QModelIndex(),index,index);
    m_data.insert(index,color);
    emit endInsertRows();
    emit countChanged(m_data.count());
}

void CppModel::append(const QString &colorValue)
{
    insert(count(),colorValue);
}

void CppModel::remove(int index)
{
    if(index<0||index>=m_data.count()) return;

    emit beginRemoveRows(QModelIndex(),index,index);
    m_data.remove(index);
    emit endRemoveRows();
    emit countChanged(m_data.count());
}

void CppModel::clear()
{
    emit beginResetModel();
    m_data.clear();
    emit endResetModel();
}

QColor CppModel::get(int index)
{
    if(index<0||index>=m_data.count()) return QColor();

    return m_data.at(index);
}

int CppModel::rowCount(const QModelIndex &parent) const
{
    return m_data.count();
}

QVariant CppModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    if(row<0||row>=m_data.count()) return QVariant();
    const QColor& color=m_data.at(row);
    switch(role){
        case NameRole:return color.name();
        case HueRole:return color.hueF();
        case SaturationRole:return color.saturationF();
        case BrightnessRole:return color.lightnessF();
    }

    return QVariant();
}

QHash<int, QByteArray> CppModel::roleNames() const
{
    return m_roleNames;
}
