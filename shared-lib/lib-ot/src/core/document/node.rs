use crate::core::NodeBody::Delta;
use crate::core::{AttributeKey, AttributeValue, NodeAttributes, OperationTransform, TextDelta};
use crate::errors::OTError;
use serde::{Deserialize, Serialize};

#[derive(Default, Clone, Serialize, Deserialize, Eq, PartialEq)]
pub struct Node {
    #[serde(rename = "type")]
    pub node_type: String,

    #[serde(skip_serializing_if = "NodeAttributes::is_empty")]
    pub attributes: NodeAttributes,

    #[serde(skip_serializing_if = "NodeBody::is_empty")]
    pub body: NodeBody,

    #[serde(skip_serializing_if = "Vec::is_empty")]
    pub children: Vec<Node>,
}

impl Node {
    pub fn new<T: ToString>(node_type: T) -> Node {
        Node {
            node_type: node_type.to_string(),
            ..Default::default()
        }
    }
}

pub struct NodeBuilder {
    node: Node,
}

impl NodeBuilder {
    pub fn new<T: ToString>(node_type: T) -> Self {
        Self {
            node: Node::new(node_type.to_string()),
        }
    }

    pub fn add_node(mut self, node: Node) -> Self {
        self.node.children.push(node);
        self
    }

    pub fn insert_attribute(mut self, key: AttributeKey, value: AttributeValue) -> Self {
        self.node.attributes.insert(key, value);
        self
    }

    pub fn set_body(mut self, body: NodeBody) -> Self {
        self.node.body = body;
        self
    }
    pub fn build(self) -> Node {
        self.node
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub enum NodeBody {
    Empty,
    Delta(TextDelta),
}

impl std::default::Default for NodeBody {
    fn default() -> Self {
        NodeBody::Empty
    }
}

impl NodeBody {
    fn is_empty(&self) -> bool {
        match self {
            NodeBody::Empty => true,
            _ => false,
        }
    }
}

impl OperationTransform for NodeBody {
    fn compose(&self, other: &Self) -> Result<Self, OTError>
    where
        Self: Sized,
    {
        match (self, other) {
            (Delta(a), Delta(b)) => a.compose(b).map(|delta| Delta(delta)),
            (NodeBody::Empty, NodeBody::Empty) => Ok(NodeBody::Empty),
            (l, r) => {
                let msg = format!("{:?} can not compose {:?}", l, r);
                Err(OTError::internal().context(msg))
            }
        }
    }

    fn transform(&self, other: &Self) -> Result<(Self, Self), OTError>
    where
        Self: Sized,
    {
        match (self, other) {
            (Delta(l), Delta(r)) => l.transform(r).map(|(ta, tb)| (Delta(ta), Delta(tb))),
            (NodeBody::Empty, NodeBody::Empty) => Ok((NodeBody::Empty, NodeBody::Empty)),
            (l, r) => {
                let msg = format!("{:?} can not compose {:?}", l, r);
                Err(OTError::internal().context(msg))
            }
        }
    }

    fn invert(&self, other: &Self) -> Self {
        match (self, other) {
            (Delta(l), Delta(r)) => Delta(l.invert(r)),
            (NodeBody::Empty, NodeBody::Empty) => NodeBody::Empty,
            (l, r) => {
                tracing::error!("{:?} can not compose {:?}", l, r);
                l.clone()
            }
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum NodeBodyChangeset {
    Delta { delta: TextDelta, inverted: TextDelta },
}

impl NodeBodyChangeset {
    pub fn inverted(&self) -> NodeBodyChangeset {
        match self {
            NodeBodyChangeset::Delta { delta, inverted } => NodeBodyChangeset::Delta {
                delta: inverted.clone(),
                inverted: delta.clone(),
            },
        }
    }
}

#[derive(Clone, Eq, PartialEq, Debug)]
pub struct NodeData {
    pub node_type: String,
    pub body: NodeBody,
    pub attributes: NodeAttributes,
}

impl NodeData {
    pub fn new(node_type: &str) -> NodeData {
        NodeData {
            node_type: node_type.into(),
            attributes: NodeAttributes::new(),
            body: NodeBody::Empty,
        }
    }

    pub fn apply_body_changeset(&mut self, changeset: &NodeBodyChangeset) {
        match changeset {
            NodeBodyChangeset::Delta { delta, inverted: _ } => match self.body.compose(&Delta(delta.clone())) {
                Ok(new_body) => self.body = new_body,
                Err(e) => tracing::error!("{:?}", e),
            },
        }
    }
}

impl std::convert::From<Node> for NodeData {
    fn from(node: Node) -> Self {
        Self {
            node_type: node.node_type,
            attributes: node.attributes,
            body: node.body,
        }
    }
}

impl std::convert::From<&Node> for NodeData {
    fn from(node: &Node) -> Self {
        Self {
            node_type: node.node_type.clone(),
            attributes: node.attributes.clone(),
            body: node.body.clone(),
        }
    }
}
