#ifndef SCREENOVERLAY_HPP
#define SCREENOVERLAY_HPP

#include <QGraphicsPixmapItem>
#include <QGraphicsRectItem>
#include <QGraphicsScene>

class ScreenOverlay : public QGraphicsScene {
    Q_OBJECT
public:
    explicit ScreenOverlay(QPixmap pixmap, QObject *parent = 0);

    void mouseMoveEvent(QGraphicsSceneMouseEvent *e) override;
    void wheelEvent(QGraphicsSceneWheelEvent *e) override;

    virtual void mouseMoved(QGraphicsSceneMouseEvent *, QPointF, QPointF) {
    }
    virtual void highlightChanged(QColor) {
    }
    virtual QString generateHint() {
        return QString();
    }

    QPixmap &pixmap() {
        return _pixmap;
    }
    void updateMag();
    virtual QString generateMagHint() {
        return QString();
    };
    void hideMag();
    void updateMagnifierGrid();
    QColor highlight() {
        return _highlight;
    }
    void setHighlight(QColor highlight);
    bool grid() {
        return _grid;
    }
    void setGrid(bool grid) {
        _grid = grid;
        if (grid) {
            updateMagnifierGrid();
        } else {
            for (auto r : gridRectsX) delete r;
            gridRectsX.clear();
            for (auto r : gridRectsY) delete r;
            gridRectsY.clear();
        }
    }
    QPointF cursorPos() {
        return _cursorPos;
    }
    void setCursorPos(QPointF cursorPos) {
        _cursorPos = cursorPos;
    }

private:
    QPointF _cursorPos = QPoint(0, 0);
    QGraphicsPixmapItem *magnifier = nullptr;
    QGraphicsRectItem *magnifierBox = nullptr;
    QGraphicsTextItem *magnifierHint = nullptr;
    QGraphicsRectItem *magnifierHintBox = nullptr;
    QGraphicsPolygonItem *cursorItem = nullptr;
    QList<QGraphicsRectItem *> gridRectsX;
    QList<QGraphicsRectItem *> gridRectsY;
    QColor _highlight = Qt::cyan;
    bool _grid = true;
    QPixmap _pixmap;
};

#endif /* SCREENOVERLAY_HPP */