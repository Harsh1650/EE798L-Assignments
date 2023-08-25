#include <stdio.h>
#include <stdlib.h>

struct node {
    int key;
    struct node *left, *right;
};
typedef struct node Node;

Node* newNode(int key) {
    Node* node = (Node*) malloc(sizeof(Node));
    node->key = key;
    node->left = node->right = NULL;
    return node;
}

Node* insert(Node* root, int key) {
    if (root == NULL) {
        return newNode(key);
    }
    if (key < root->key) {
        root->left = insert(root->left, key);
    } else if (key > root->key) {
        root->right = insert(root->right, key);
    }
    return root;
}

Node* search(Node* root, int key) {
    if (root == NULL || root->key == key) {
        return root;
    }
    if (key < root->key) {
        return search(root->left, key);
    } else {
        return search(root->right, key);
    }
}

Node* deleteMin(Node* root) {
    if (root == NULL) {
        return NULL;
    }
    if (root->left == NULL) {
        Node* temp = root->right;
        free(root);
        return temp;
    }
    root->left = deleteMin(root->left);
    return root;
}

Node* delete(Node* root, int key) {
    if (root == NULL) {
        return NULL;
    }
    if (key < root->key) {
        root->left = delete(root->left, key);
    } else if (key > root->key) {
        root->right = delete(root->right, key);
    } else {
        if (root->left == NULL) {
            Node* temp = root->right;
            free(root);
            return temp;
        } else if (root->right == NULL) {
            Node* temp = root->left;
            free(root);
            return temp;
        }
        Node* temp = root->right;
        while (temp->left != NULL) {
            temp = temp->left;
        }
        root->key = temp->key;
        root->right = delete(root->right, temp->key);
    }
    return root;
}

void inorder(Node* root) {
    if (root != NULL) {
        inorder(root->left);
        printf("%d ", root->key);
        inorder(root->right);
    }
}

int main() {
    Node* root = NULL;
    root = insert(root, 50);
    insert(root, 30);
    insert(root, 20);
    insert(root, 40);
    insert(root, 70);
    insert(root, 60);
    insert(root, 80);

    printf("Inorder traversal of the BST: ");
    inorder(root);

    printf("\nDeleting 20 from the BST\n");
    root = delete(root, 20);
    printf("Inorder traversal of the modified BST: ");
    inorder(root);

    printf("\nDeleting minimum element from the BST\n");
    root = deleteMin(root);
    printf("Inorder traversal of the modified BST: ");
    inorder(root);

    printf("\nDeleting 70 from the BST\n");
    root = delete(root, 70);
    printf("Inorder traversal of the modified BST: ");
    inorder(root);

    return 0;
}
