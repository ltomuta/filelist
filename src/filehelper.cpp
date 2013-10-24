/**
 * Copyright (c) 2011-2012 Nokia Corporation.
 */

// Own header
#include "filehelper.h"

// Qt includes
#include <QDateTime>
#include <QDebug>
#include <QDesktopServices>
#include <QFileInfo>
#include <QStringList>
#include <QSystemStorageInfo>
#include <QtCore/qmath.h>
#include <QDir>

#ifdef Q_OS_SYMBIAN
#include <f32file.h>
#include <PathInfo.h>
#endif

// Qt Mobility namespace
QTM_USE_NAMESPACE


/*!
  \class FileHelper
  \brief A helper class for resolving the appropriate content paths, file
         sizes etc. and allowing that data to be accessed within QML code.
*/


/*!
  Constructor.
*/
FileHelper::FileHelper(QObject *parent)
    : QObject(parent)
{
    resolvePaths();
}


/*!
  Destructor.
*/
FileHelper::~FileHelper()
{
}


/*!
  Returns the default phone memory path containing the images.
*/
QString FileHelper::phoneMemoryImagesPath() const
{
    return m_phoneMemoryImagesPath;
}

/*!
  Returns the default phone memory path containing the sounds.
*/
QString FileHelper::phoneMemorySoundsPath() const
{
    return m_phoneMemorySoundsPath;
}


/*!
  Returns the default phone memory path containing the videos.
*/
QString FileHelper::phoneMemoryVideosPath() const
{
    return m_phoneMemoryVideosPath;
}

/*!
  Returns the default memory card path containing the images.
*/
QString FileHelper::memoryCardImagesPath() const
{
    return m_memoryCardImagesPath;
}

/*!
  Returns the default memory card path containing the sounds.
*/
QString FileHelper::memoryCardSoundsPath() const
{
    return m_memoryCardSoundsPath;
}


/*!
  Returns the default memory card path containing the videos.
*/
QString FileHelper::memoryCardVideosPath() const
{
    qDebug() << "Memory card videos" << m_memoryCardVideosPath;
    return m_memoryCardVideosPath;
}

/*!
  Returns true if a memory card is present on the device, false otherwise.
*/
bool FileHelper::memoryCardPresent()
{
    QSystemStorageInfo storageInfo;
    QStringList driveList = storageInfo.logicalDrives();
    bool found(false);

#ifdef Q_OS_SYMBIAN
    QString memCardRootPath =
            descriptorToString(PathInfo::MemoryCardRootPath());
    qDebug() << "Memory card root path is" << memCardRootPath;

    qint64 free, total;
    getFreeSpaceAndTotalSpace(free, total, false);

    foreach (QString drive, driveList) {
        qDebug() << "FileHelper::memoryCardPresent():"
                 << drive << "is of type" << storageInfo.typeForDrive(drive);
        qDebug() << "Total drive space: " << total;

        if (memCardRootPath.startsWith(drive) && total
                /*&& storageInfo.typeForDrive(drive) ==
                                    QSystemStorageInfo::RemovableDrive*/) {
            qDebug() << "Drive" << drive << "could be a memory card";

            // We could just return 'true' here but for the sake of debug
            // printing all the drives, let's continue.
            found = true;
        }
    }
#endif

    return found;
}


/*!
  Converts \a path into URL.
*/
QUrl FileHelper::pathUrl(const QString &path) const
{
    return QUrl::fromLocalFile(path);
}


/*!
  Returns the size of the file in \a filePath.
*/
QString FileHelper::size(const QUrl &filePath) const
{
    QFileInfo fileInfo(filePath.toLocalFile());

    if (fileInfo.isFile()) {
        return formattedSize(fileInfo.size());
    }

    return QString();
}


/*!
  Returns true if the directory given as a \a url is empty, otherwise false.
*/
bool FileHelper::isDirEmpty(const QUrl &url) const
{
    QDir directory(url.toLocalFile());

    bool ret = (directory.count() == 0) ? true : false;

    return ret;
}


/*!
  Returns the date and time when the file in \a filePath was created.
*/
QString FileHelper::created(const QUrl &filePath) const
{
    QFileInfo fileInfo(filePath.toLocalFile());
    return fileInfo.created().toString("MM/dd/yyyy h:mm:ss AP");
}


/*!
  Returns the free and the total phone memory space of a volume as a string.
*/
QString FileHelper::phoneMemoryFreeAndTotalSpace() const
{
    qint64 freeSpace(0);
    qint64 totalSpace(0);

    if (getFreeSpaceAndTotalSpace(freeSpace, totalSpace, true)) {
        return formattedSize(freeSpace) + " free of "
                + formattedSize(totalSpace);
    }

    return QString();
}

/*!
  Returns the free and the total memory card space of a volume as a string.
*/

QString FileHelper::memoryCardFreeAndTotalSpace() const
{
    qint64 freeSpace(0);
    qint64 totalSpace(0);

    if (getFreeSpaceAndTotalSpace(freeSpace, totalSpace, false)) {
        return formattedSize(freeSpace) + " free of "
                + formattedSize(totalSpace);
    }

    return QString();
}


/*!
  Extracts and returns the local file as string from \a url.
*/
QString FileHelper::urlToLocalFile(const QUrl &url) const
{
    qDebug() << url << "=>" << url.toLocalFile();
    return url.toLocalFile();
}


/*!
  Opens \a url.
  \see http://doc.qt.nokia.com/latest/qdesktopservices.html#openUrl
*/
bool FileHelper::openUrl(const QUrl &url) const
{
    return QDesktopServices::openUrl(url);
}


/*!
  Resolves the paths for each content.
*/
void FileHelper::resolvePaths()
{
#ifdef Q_OS_SYMBIAN
    QString rootPath;

    rootPath = descriptorToString(PathInfo::PhoneMemoryRootPath());

    m_phoneMemoryImagesPath = rootPath + descriptorToString(PathInfo::ImagesPath());
    m_phoneMemorySoundsPath = rootPath + descriptorToString(PathInfo::SoundsPath());
    m_phoneMemoryVideosPath = rootPath + descriptorToString(PathInfo::VideosPath());

    rootPath = descriptorToString(PathInfo::MemoryCardRootPath());

    if(rootPath.length() > 0) {
        m_memoryCardImagesPath = rootPath + descriptorToString(PathInfo::ImagesPath());
        m_memoryCardSoundsPath = rootPath + descriptorToString(PathInfo::SoundsPath());
        m_memoryCardVideosPath = rootPath + descriptorToString(PathInfo::VideosPath());
    }

#endif
    qDebug() << "FileHelper::resolvePaths():"
             << m_phoneMemoryImagesPath << ";"
             << m_phoneMemorySoundsPath << ";"
             << m_phoneMemoryVideosPath << ";"
             << m_memoryCardImagesPath << ";"
             << m_memoryCardSoundsPath << ";"
             << m_memoryCardVideosPath;


    emit phoneMemoryImagesPathChanged(m_phoneMemoryImagesPath);
    emit phoneMemorySoundsPathhanged(m_phoneMemorySoundsPath);
    emit phoneMemoryVideosPathChanged(m_phoneMemoryVideosPath);

    emit memoryCardImagesPathChanged(m_memoryCardImagesPath);
    emit memoryCardSoundsPathChanged(m_memoryCardSoundsPath);
    emit memoryCardVideosPathChanged(m_memoryCardVideosPath);
}


/*!
  Returns the size of \a bytes in a formatted string.
*/
QString FileHelper::formattedSize(qint64 bytes) const
{
    int log10OfBytes = qFloor(log10((long double)bytes));
    QString unit;
    int power(0);

    if (log10OfBytes < 3) {
        unit = " bytes";
    }
    else if (log10OfBytes < 6) {
        unit = " kB";
        power = 3;
    }
    else if (log10OfBytes < 9) {
        unit = " MB";
        power = 6;
    }
    else {
        unit = " GB";
        power = 9;
    }

    QString formatted = QString().sprintf("%.1f", bytes / qPow(10, power));
    formatted += unit;
    return formatted;
}

/*!
  Gets the free and the total space of the phone or mass memory drive.
  Returns true if successful, false otherwise.
*/
bool FileHelper::getFreeSpaceAndTotalSpace(qint64 &free,
                                           qint64 &total,
                                           bool phoneMemory) const
{
#ifdef Q_OS_SYMBIAN
    RFs fs;
    fs.Connect();
    TVolumeInfo volumeInfo;
    TInt drive;

    if ( phoneMemory )
    {
        drive = driveEnum(descriptorToString(PathInfo::PhoneMemoryRootPath()));
    }
    else
    {
        drive = driveEnum(descriptorToString(PathInfo::MemoryCardRootPath()));
    }

    fs.Volume( volumeInfo, drive );
    free = (qint64)volumeInfo.iFree;
    total = (qint64)volumeInfo.iSize;
    fs.Close();
    return true;
#endif

    return false;
}


#ifdef Q_OS_SYMBIAN

/*!
  Convers Symbian descriptor \a desc into a QString.
*/
QString FileHelper::descriptorToString(const TDesC &desc) const
{
    return QString((QChar*)desc.Ptr(), desc.Length());
}


/*!
  Returns the enumerator value for \a drive.
*/
TInt FileHelper::driveEnum(const QString &drive) const
{
    if (drive.isEmpty()) {
        return -1;
    }

    QString driveUpper = drive.toUpper();
    QChar driveLetter = driveUpper.at(0);
    TInt value(-1);

    if (driveLetter == 'C') {
        value = EDriveC;
    }
    else if (driveLetter == 'D') {
        value = EDriveD;
    }
    else if (driveLetter == 'E') {
        value = EDriveE;
    }
    else if (driveLetter == 'F') {
        value = EDriveF;
    }

    return value;
}

#endif


// End of file.
